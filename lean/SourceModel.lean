import Mathlib.Analysis.Convex.Function
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import Mathlib.Order.Hom.Set

/-!
# Source model for Ide--Talamàs (2025)

This file formalizes the primitives and the competitive-equilibrium definition
used by arXiv:2312.05481v11. Human knowledge is represented by real numbers
in `[0,1]`; the population measure has a continuous, strictly positive density;
and each equilibrium outcome records the five human occupations, human-human
matching, the allocation of compute, wages, and the rental rate of compute.

The numbered propositions are deliberately not fields of these structures.
They are stated, source-facing, in `PaperInterface.lean`.
-/

namespace IT25KnowledgeEconomy

open scoped Interval
open MeasureTheory Set

noncomputable section

/-- The source domain of human knowledge and problem difficulty. -/
def knowledgeDomain : Set ℝ := Set.Icc 0 1

/-- The exogenous economy common to the pre- and post-AI comparisons. -/
structure Economy where
  /-- The distribution `G` of human knowledge. -/
  population : Measure ℝ
  /-- The cumulative distribution function `G`. -/
  distribution : ℝ → ℝ
  /-- The continuous, strictly positive density `g`. -/
  density : ℝ → ℝ
  /-- The fixed time cost `h` of a request for help. -/
  helpCost : ℝ
  /-- The exogenous stock `μ` of compute. -/
  compute : ℝ
  population_is_probability : IsProbabilityMeasure population
  population_supported : population (knowledgeDomainᶜ) = 0
  distribution_eq_measure :
    ∀ z, distribution z = (population (Set.Iic z)).toReal
  density_represents_population :
    ∀ s, MeasurableSet s →
      (population s).toReal = ∫ z in s, density z
  density_continuous : Continuous density
  density_positive : ∀ z ∈ knowledgeDomain, 0 < density z
  helpCost_positive : 0 < helpCost
  helpCost_lt_one : helpCost < 1
  compute_nonnegative : 0 ≤ compute

/-- AI is absent, autonomous (co-worker and co-pilot), or non-autonomous
(co-pilot only). -/
inductive AIMode where
  | preAI
  | autonomous
  | nonAutonomous
  deriving DecidableEq

/-- An AI technology has source-admissible knowledge exactly when
`zAI ∈ [0,1)`. -/
def AdmissibleAI (zAI : ℝ) : Prop := zAI ∈ Set.Ico (0 : ℝ) 1

/-- With problem difficulty uniform on `[0,1]`, knowledge `z` is the fraction
of production problems solved independently. -/
def independentSuccessProbability (z : ℝ) : ℝ := z

/-- Team size `n(z)`, characterized in the paper by
`h * n(z) * (1-z) = 1`. -/
def teamSize (economy : Economy) (z : ℝ) : ℝ :=
  1 / (economy.helpCost * (1 - z))

/-- The objects that comprise a competitive equilibrium in the source. -/
structure EquilibriumOutcome where
  computeIndependent : ℝ
  computeWorkers : ℝ
  computeSolvers : ℝ
  independent : Set ℝ
  humanWorkersByPeople : Set ℝ
  humanWorkersByAI : Set ℝ
  humanSolversForPeople : Set ℝ
  humanSolversForAI : Set ℝ
  matching : ℝ → ℝ
  employeeMatching : ℝ → ℝ
  wage : ℝ → ℝ
  rentalRate : ℝ

/-- `W = W_a ∪ W_p`. -/
def humanWorkers (outcome : EquilibriumOutcome) : Set ℝ :=
  outcome.humanWorkersByAI ∪ outcome.humanWorkersByPeople

/-- `S = S_a ∪ S_p`. -/
def humanSolvers (outcome : EquilibriumOutcome) : Set ℝ :=
  outcome.humanSolversForAI ∪ outcome.humanSolversForPeople

/-- The paper's relation `B ≼ B'`: `sup B ≤ inf B'`. -/
def LiesBelow (lower upper : Set ℝ) : Prop :=
  sSup lower ≤ sInf upper

/-- All five human occupation sets, in the source's order. -/
def humanOccupationSets (outcome : EquilibriumOutcome) : List (Set ℝ) :=
  [outcome.independent, outcome.humanWorkersByPeople,
    outcome.humanWorkersByAI, outcome.humanSolversForPeople,
    outcome.humanSolversForAI]

/-- The source's requirement that any two occupation sets intersect only on a
population-null set. -/
def PairwiseAlmostDisjoint (economy : Economy)
    (sets : List (Set ℝ)) : Prop :=
  sets.Pairwise fun first second => economy.population (first ∩ second) = 0

/-- Equation (1), including its measurable-subset quantifier. -/
def MatchingResourceConstraint (economy : Economy)
    (outcome : EquilibriumOutcome) : Prop :=
  Set.MapsTo outcome.matching outcome.humanWorkersByPeople
      outcome.humanSolversForPeople ∧
    Set.MapsTo outcome.employeeMatching outcome.humanSolversForPeople
      outcome.humanWorkersByPeople ∧
    Set.LeftInvOn outcome.employeeMatching outcome.matching
      outcome.humanWorkersByPeople ∧
    Set.LeftInvOn outcome.matching outcome.employeeMatching
      outcome.humanSolversForPeople ∧
    ∀ Y, MeasurableSet Y → Y ⊆ outcome.humanWorkersByPeople →
      (∫ u in Y, economy.helpCost * (1 - u) ∂economy.population) =
        ∫ _u in outcome.matching '' Y, (1 : ℝ) ∂economy.population

/-- The compute identities immediately preceding equation (1). -/
def ComputeAccounting (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) : Prop :=
  outcome.computeSolvers =
      ∫ z in outcome.humanWorkersByAI,
        economy.helpCost * (1 - z) ∂economy.population ∧
    outcome.computeWorkers =
      teamSize economy zAI *
        (economy.population outcome.humanSolversForAI).toReal

/-- Profit of a one-layer firm employing a human. -/
def singleHumanProfit (outcome : EquilibriumOutcome) (z : ℝ) : ℝ :=
  independentSuccessProbability z - outcome.wage z

/-- Profit of an autonomous one-layer AI firm. -/
def singleAIProfit (zAI : ℝ) (outcome : EquilibriumOutcome) : ℝ :=
  zAI - outcome.rentalRate

/-- Profit `Π₂ᵗᴬ(z)` of a firm with human workers and an AI solver. -/
def topAutomatedProfit (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) (z : ℝ) : ℝ :=
  teamSize economy z * (zAI - outcome.wage z) - outcome.rentalRate

/-- Profit `Π₂ᵇᴬ(s)` of a firm with AI workers and a human solver. -/
def bottomAutomatedProfit (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) (s : ℝ) : ℝ :=
  teamSize economy zAI * (s - outcome.rentalRate) - outcome.wage s

/-- Profit `Π₂ⁿᴬ(s,z)` of a two-layer, all-human firm. -/
def humanTeamProfit (economy : Economy) (outcome : EquilibriumOutcome)
    (s z : ℝ) : ℝ :=
  teamSize economy z * (s - outcome.wage z) - outcome.wage s

/-- Every feasible organizational form makes nonpositive profit, while every
form used by the allocation makes zero profit. This is the source's
"firms optimally choose their structure (while earning zero profits)" clause,
expanded using the displayed profit formulas. -/
def FirmsChooseOptimally (economy : Economy) (zAI : ℝ) (mode : AIMode)
    (outcome : EquilibriumOutcome) : Prop :=
  (∀ z ∈ knowledgeDomain, singleHumanProfit outcome z ≤ 0) ∧
    (∀ z ∈ knowledgeDomain, ∀ s ∈ knowledgeDomain, z ≤ s →
      humanTeamProfit economy outcome s z ≤ 0) ∧
    (mode = AIMode.autonomous →
      singleAIProfit zAI outcome ≤ 0 ∧
        (∀ z ∈ knowledgeDomain, z ≤ zAI →
          topAutomatedProfit economy zAI outcome z ≤ 0) ∧
        (∀ s ∈ knowledgeDomain, zAI ≤ s →
          bottomAutomatedProfit economy zAI outcome s ≤ 0)) ∧
    (mode = AIMode.nonAutonomous →
      ∀ z ∈ knowledgeDomain, z ≤ zAI →
        topAutomatedProfit economy zAI outcome z ≤ 0) ∧
    (∀ z ∈ outcome.independent, singleHumanProfit outcome z = 0) ∧
    (∀ z ∈ outcome.humanWorkersByPeople,
      humanTeamProfit economy outcome (outcome.matching z) z = 0) ∧
    (∀ z ∈ outcome.humanWorkersByAI,
      topAutomatedProfit economy zAI outcome z = 0) ∧
    (∀ s ∈ outcome.humanSolversForAI,
      bottomAutomatedProfit economy zAI outcome s = 0) ∧
    (mode = AIMode.autonomous → 0 < outcome.computeIndependent →
      singleAIProfit zAI outcome = 0)

/-- The compute available in a pre-AI comparison is zero; in either AI regime
it is the exogenous stock `μ`. -/
def availableCompute (economy : Economy) (mode : AIMode) : ℝ :=
  if mode = AIMode.preAI then 0 else economy.compute

/-- Technology-specific restrictions on which automated firms can operate. -/
def ModeRestrictions (mode : AIMode) (outcome : EquilibriumOutcome) : Prop :=
  match mode with
  | AIMode.preAI =>
      outcome.computeIndependent = 0 ∧ outcome.computeWorkers = 0 ∧
        outcome.computeSolvers = 0 ∧ outcome.humanWorkersByAI = ∅ ∧
        outcome.humanSolversForAI = ∅
  | AIMode.autonomous => True
  | AIMode.nonAutonomous =>
      outcome.computeWorkers = 0 ∧ outcome.humanSolversForAI = ∅

/-- Market clearing, including no unemployment and the interpretation of
unused compute in the non-autonomous regime. -/
def MarketsClear (economy : Economy) (zAI : ℝ) (mode : AIMode)
    (outcome : EquilibriumOutcome) : Prop :=
  0 ≤ outcome.computeIndependent ∧ 0 ≤ outcome.computeWorkers ∧
    0 ≤ outcome.computeSolvers ∧
    outcome.computeIndependent + outcome.computeWorkers +
        outcome.computeSolvers = availableCompute economy mode ∧
    MeasurableSet outcome.independent ∧
    MeasurableSet outcome.humanWorkersByPeople ∧
    MeasurableSet outcome.humanWorkersByAI ∧
    MeasurableSet outcome.humanSolversForPeople ∧
    MeasurableSet outcome.humanSolversForAI ∧
    outcome.independent ∪ outcome.humanWorkersByPeople ∪
        outcome.humanWorkersByAI ∪ outcome.humanSolversForPeople ∪
        outcome.humanSolversForAI = knowledgeDomain ∧
    PairwiseAlmostDisjoint economy (humanOccupationSets outcome) ∧
    MatchingResourceConstraint economy outcome ∧
    ComputeAccounting economy zAI outcome ∧
    (∀ z ∈ knowledgeDomain, 0 ≤ outcome.wage z) ∧
    0 ≤ outcome.rentalRate ∧
    ModeRestrictions mode outcome ∧
    (mode = AIMode.nonAutonomous → 0 < outcome.computeIndependent →
      outcome.rentalRate = 0)

/-- The paper's displayed definition of competitive equilibrium. -/
def CompetitiveEquilibrium (economy : Economy) (zAI : ℝ) (mode : AIMode)
    (outcome : EquilibriumOutcome) : Prop :=
  FirmsChooseOptimally economy zAI mode outcome ∧
    MarketsClear economy zAI mode outcome

/-- Equality of all economically meaningful equilibrium objects. The source
types `m` only on `W_p` and `e` only on `S_p`, whereas the Lean representation
uses total functions, so uniqueness must ignore their irrelevant values. -/
def EquilibriumEquivalent (first second : EquilibriumOutcome) : Prop :=
  first.computeIndependent = second.computeIndependent ∧
    first.computeWorkers = second.computeWorkers ∧
    first.computeSolvers = second.computeSolvers ∧
    first.independent = second.independent ∧
    first.humanWorkersByPeople = second.humanWorkersByPeople ∧
    first.humanWorkersByAI = second.humanWorkersByAI ∧
    first.humanSolversForPeople = second.humanSolversForPeople ∧
    first.humanSolversForAI = second.humanSolversForAI ∧
    Set.EqOn first.matching second.matching first.humanWorkersByPeople ∧
    Set.EqOn first.employeeMatching second.employeeMatching
      first.humanSolversForPeople ∧
    Set.EqOn first.wage second.wage knowledgeDomain ∧
    first.rentalRate = second.rentalRate

/-- Uniqueness in the paper's own domains of definition. -/
def UniqueCompetitiveEquilibrium (economy : Economy) (zAI : ℝ)
    (mode : AIMode) (outcome : EquilibriumOutcome) : Prop :=
  CompetitiveEquilibrium economy zAI mode outcome ∧
    ∀ alternative, CompetitiveEquilibrium economy zAI mode alternative →
      EquilibriumEquivalent alternative outcome

/-- Compute is abundant relative to human time: in either AI regime, every
equilibrium leaves a positive amount for independent AI production
(autonomous AI) or idle (non-autonomous AI). -/
def ComputeAbundant (economy : Economy) (zAI : ℝ) : Prop :=
  ∀ mode, mode ≠ AIMode.preAI → ∀ outcome,
    CompetitiveEquilibrium economy zAI mode outcome →
      0 < outcome.computeIndependent

/-- The paper's maintained abundance condition simultaneously over all
source-admissible AI knowledge levels. -/
def UniformlyComputeAbundant (economy : Economy) : Prop :=
  ∀ zAI, AdmissibleAI zAI → ComputeAbundant economy zAI

/-- Aggregate output from the five source firm configurations. -/
noncomputable def totalOutput (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) : ℝ :=
  (∫ z in outcome.independent,
    independentSuccessProbability z ∂economy.population) +
    zAI * outcome.computeIndependent +
    (∫ z in outcome.humanWorkersByPeople,
      outcome.matching z ∂economy.population) +
    (∫ z in outcome.humanSolversForAI,
      teamSize economy zAI * z ∂economy.population) +
    ∫ _z in outcome.humanWorkersByAI, zAI ∂economy.population

/-- Total labor income `∫₀¹ w(z)dG(z)`. -/
noncomputable def laborIncome (economy : Economy)
    (outcome : EquilibriumOutcome) : ℝ :=
  ∫ z in knowledgeDomain, outcome.wage z ∂economy.population

/-- Total capital income `μr`. -/
def capitalIncome (economy : Economy)
    (outcome : EquilibriumOutcome) : ℝ :=
  economy.compute * outcome.rentalRate

/-- Efficiency means maximizing aggregate output among feasible,
market-clearing allocations in the same technological regime. -/
def Efficient (economy : Economy) (zAI : ℝ) (mode : AIMode)
    (outcome : EquilibriumOutcome) : Prop :=
  MarketsClear economy zAI mode outcome ∧
    ∀ alternative, MarketsClear economy zAI mode alternative →
      totalOutput economy zAI alternative ≤ totalOutput economy zAI outcome

/-- The analogous labor-income maximization criterion used in Proposition 6. -/
def LaborIncomeMaximizing (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) : Prop :=
  MarketsClear economy zAI AIMode.nonAutonomous outcome ∧
    ∀ alternative,
      MarketsClear economy zAI AIMode.nonAutonomous alternative →
        laborIncome economy alternative ≤ laborIncome economy outcome

/-- The threshold property introduced in Proposition 1 and maintained in
Sections 4--6. -/
def IsPreAIThreshold (economy : Economy) (pre : EquilibriumOutcome)
    (h0 : ℝ) : Prop :=
  h0 ∈ Set.Ioo (0 : ℝ) 1 ∧
    (pre.independent.Nonempty ↔ economy.helpCost > h0)

/-- The source calls AI basic when its knowledge lies in the interior of the
pre-AI worker set. -/
def BasicAI (zAI : ℝ) (pre : EquilibriumOutcome) : Prop :=
  zAI ∈ interior (humanWorkers pre)

/-- The source calls AI advanced when its knowledge lies in the interior of
the pre-AI solver set. -/
def AdvancedAI (zAI : ℝ) (pre : EquilibriumOutcome) : Prop :=
  zAI ∈ interior (humanSolvers pre)

/-- Average worker productivity: the knowledge of the worker's solver. -/
def productivity (zAI : ℝ) (outcome : EquilibriumOutcome) (z : ℝ) : ℝ := by
  classical
  exact if z ∈ outcome.humanWorkersByAI then zAI else outcome.matching z

/-- A solver's span of control. -/
def spanOfControl (economy : Economy) (zAI : ℝ)
    (outcome : EquilibriumOutcome) (z : ℝ) : ℝ := by
  classical
  exact if z ∈ outcome.humanSolversForAI then teamSize economy zAI
    else teamSize economy (outcome.employeeMatching z)

/-- Humans below AI knowledge who earn a strictly higher post-AI wage. -/
def bottomWinners (zAI : ℝ) (pre post : EquilibriumOutcome) : Set ℝ :=
  {z | z ∈ Set.Icc (0 : ℝ) zAI ∧ post.wage z > pre.wage z}

/-- Humans above AI knowledge who earn a strictly higher post-AI wage. -/
def topWinners (zAI : ℝ) (pre post : EquilibriumOutcome) : Set ℝ :=
  {z | z ∈ Set.Icc zAI 1 ∧ post.wage z > pre.wage z}

/-- Equality of human occupational assignments, abstracting from which kind of
solver or worker is on the other layer of a team. -/
def SameHumanOccupations (first second : EquilibriumOutcome) : Prop :=
  first.independent = second.independent ∧
    humanWorkers first = humanWorkers second ∧
    humanSolvers first = humanSolvers second

end

end IT25KnowledgeEconomy
