import IT25KnowledgeEconomy.SourceModel

/-!
# Paper interface: Artificial Intelligence in the Knowledge Economy

This is the source-facing statement surface for arXiv:2312.05481v11.
The model declarations used below are in `SourceModel.lean`; in particular,
`CompetitiveEquilibrium` is the paper's displayed definition rather than a
result-bearing certificate. Each numbered proposition has exactly one
transparent `...Spec : Prop` here and one proof endpoint in
`ProofInterface.lean`.
-/

namespace IT25KnowledgeEconomy

open scoped Interval
open Set

/-- Proposition 1 (source.txt:704-715): the unique, efficient pre-AI
equilibrium, its occupational/matching structure, and every stated wage
property and formula. -/
def proposition1Spec : Prop :=
  ∀ economy : Economy,
    ∃ pre : EquilibriumOutcome,
      UniqueCompetitiveEquilibrium economy 0 AIMode.preAI pre ∧
      Efficient economy 0 AIMode.preAI pre ∧
      LiesBelow (humanWorkers pre) pre.independent ∧
      LiesBelow pre.independent (humanSolvers pre) ∧
      StrictMonoOn pre.matching (humanWorkers pre) ∧
      (humanWorkers pre).Nonempty ∧
      (humanSolvers pre).Nonempty ∧
      ∃ h0 C : ℝ,
        IsPreAIThreshold economy pre h0 ∧
        ContinuousOn pre.wage knowledgeDomain ∧
        StrictMonoOn pre.wage knowledgeDomain ∧
        ConvexOn ℝ knowledgeDomain pre.wage ∧
        StrictConvexOn ℝ (humanWorkers pre ∪ humanSolvers pre) pre.wage ∧
        (∀ z ∈ humanWorkers pre,
          pre.wage z =
            pre.matching z -
              pre.wage (pre.matching z) / teamSize economy z) ∧
        (∀ z ∈ pre.independent, pre.wage z = z) ∧
        (∀ z ∈ humanSolvers pre,
          pre.wage z =
              C + ∫ u in sInf (humanSolvers pre)..z,
                teamSize economy (pre.employeeMatching u) ∧
            z < pre.wage z) ∧
        (economy.helpCost < h0 → sInf (humanSolvers pre) < C) ∧
        (h0 ≤ economy.helpCost → C = sInf (humanSolvers pre)) ∧
        (∀ z ∈ knowledgeDomain,
          z ∉ closure pre.independent → z < pre.wage z) ∧
        (economy.helpCost < h0 →
          ∀ z ∈ knowledgeDomain, z < pre.wage z)

/-- Proposition 2 (source.txt:823-850): the unique, efficient autonomous-AI
equilibrium under the maintained `h < h₀` regime, including all occupational,
AI-use, price, wage-formula, and boundary claims. -/
def proposition2Spec : Prop :=
  ∀ (economy : Economy) (zAI : ℝ) (pre : EquilibriumOutcome) (h0 : ℝ),
    AdmissibleAI zAI →
    ComputeAbundant economy zAI →
    CompetitiveEquilibrium economy 0 AIMode.preAI pre →
    IsPreAIThreshold economy pre h0 →
    economy.helpCost < h0 →
    ∃ post : EquilibriumOutcome,
      UniqueCompetitiveEquilibrium economy zAI AIMode.autonomous post ∧
      Efficient economy zAI AIMode.autonomous post ∧
      LiesBelow (humanWorkers post) post.independent ∧
      LiesBelow post.independent (humanSolvers post) ∧
      LiesBelow (humanWorkers post) ({zAI} : Set ℝ) ∧
      LiesBelow ({zAI} : Set ℝ) (humanSolvers post) ∧
      StrictMonoOn post.matching post.humanWorkersByPeople ∧
      LiesBelow post.humanWorkersByAI post.humanWorkersByPeople ∧
      LiesBelow post.humanSolversForPeople post.humanSolversForAI ∧
      0 < post.computeIndependent ∧
      (zAI ∈ humanWorkers pre → 0 < post.computeWorkers) ∧
      (zAI ∈ humanSolvers pre → 0 < post.computeSolvers) ∧
      post.rentalRate = zAI ∧
      ContinuousOn post.wage knowledgeDomain ∧
      StrictMonoOn post.wage knowledgeDomain ∧
      ConvexOn ℝ knowledgeDomain post.wage ∧
      StrictConvexOn ℝ
        (post.humanWorkersByPeople ∪ post.humanSolversForPeople) post.wage ∧
      (∀ z ∈ post.humanWorkersByAI,
        post.wage z = zAI * (1 - 1 / teamSize economy z) ∧
          z < post.wage z) ∧
      (∀ z ∈ post.humanWorkersByPeople,
        post.wage z =
          post.matching z -
            post.wage (post.matching z) / teamSize economy z) ∧
      (∀ z ∈ post.independent, post.wage z = z) ∧
      (∀ z ∈ post.humanSolversForPeople,
        post.wage z =
          sInf post.humanSolversForPeople +
            ∫ u in sInf post.humanSolversForPeople..z,
              teamSize economy (post.employeeMatching u)) ∧
      (∀ z ∈ post.humanSolversForAI,
        post.wage z = teamSize economy zAI * (z - zAI) ∧
          z < post.wage z) ∧
      post.wage (sSup (humanWorkers post)) =
        sSup post.humanWorkersByPeople ∧
      post.wage zAI = zAI ∧
      post.wage (sInf (humanSolvers post)) =
        sInf post.humanSolversForPeople

/-- Proposition 3 (source.txt:1025-1027): basic and advanced AI move the
human worker/solver cutoffs in opposite directions. -/
def proposition3Spec : Prop :=
  ∀ (economy : Economy) (zAI : ℝ) (pre post : EquilibriumOutcome) (h0 : ℝ),
    AdmissibleAI zAI →
    ComputeAbundant economy zAI →
    CompetitiveEquilibrium economy 0 AIMode.preAI pre →
    CompetitiveEquilibrium economy zAI AIMode.autonomous post →
    IsPreAIThreshold economy pre h0 →
    economy.helpCost < h0 →
    (BasicAI zAI pre →
      humanWorkers post ⊂ humanWorkers pre ∧
        humanSolvers pre ⊂ humanSolvers post) ∧
    (AdvancedAI zAI pre →
      humanWorkers pre ⊂ humanWorkers post ∧
        humanSolvers post ⊂ humanSolvers pre)

/-- Proposition 4 (source.txt:1042-1048): the complete productivity and span
comparative statics for basic and advanced AI. -/
def proposition4Spec : Prop :=
  ∀ (economy : Economy) (zAI : ℝ) (pre post : EquilibriumOutcome) (h0 : ℝ),
    AdmissibleAI zAI →
    ComputeAbundant economy zAI →
    CompetitiveEquilibrium economy 0 AIMode.preAI pre →
    CompetitiveEquilibrium economy zAI AIMode.autonomous post →
    IsPreAIThreshold economy pre h0 →
    economy.helpCost < h0 →
    (BasicAI zAI pre →
      (∀ z ∈ humanWorkers post,
        productivity zAI post z < productivity 0 pre z) ∧
      (∀ z ∈ humanSolvers pre,
        (pre.employeeMatching z < zAI →
          spanOfControl economy 0 pre z <
            spanOfControl economy zAI post z) ∧
        (pre.employeeMatching z > zAI →
          spanOfControl economy zAI post z <
            spanOfControl economy 0 pre z))) ∧
    (AdvancedAI zAI pre →
      (∀ z ∈ humanWorkers pre,
        (z < pre.employeeMatching zAI →
          productivity 0 pre z < productivity zAI post z) ∧
        (z > pre.employeeMatching zAI →
          productivity zAI post z < productivity 0 pre z)) ∧
      (∀ z ∈ humanSolvers post,
        spanOfControl economy 0 pre z <
          spanOfControl economy zAI post z))

/-- Proposition 5 (source.txt:1177-1178): a cutoff inside the pre-AI worker
set governs bottom winners, while top winners exist at every admissible AI
knowledge level. -/
def proposition5Spec : Prop :=
  ∀ (economy : Economy) (pre : EquilibriumOutcome) (h0 : ℝ),
    UniformlyComputeAbundant economy →
    CompetitiveEquilibrium economy 0 AIMode.preAI pre →
    IsPreAIThreshold economy pre h0 →
    economy.helpCost < h0 →
    ∃ threshold : ℝ,
      threshold ∈ interior (humanWorkers pre) ∧
      ∀ zAI, AdmissibleAI zAI →
        ∀ post,
          CompetitiveEquilibrium economy zAI AIMode.autonomous post →
            ((bottomWinners zAI pre post).Nonempty ↔ threshold < zAI) ∧
              (topWinners zAI pre post).Nonempty

/-- Proposition 6 (source.txt:1361-1374): the unique non-autonomous-AI
equilibrium and all four output/wage comparisons with pre-AI and autonomous
AI. -/
def proposition6Spec : Prop :=
  ∀ (economy : Economy) (zAI : ℝ) (pre autonomous : EquilibriumOutcome)
      (h0 : ℝ),
    AdmissibleAI zAI →
    ComputeAbundant economy zAI →
    CompetitiveEquilibrium economy 0 AIMode.preAI pre →
    CompetitiveEquilibrium economy zAI AIMode.autonomous autonomous →
    IsPreAIThreshold economy pre h0 →
    economy.helpCost < h0 →
    ∃ nonAutonomous : EquilibriumOutcome,
      UniqueCompetitiveEquilibrium economy zAI AIMode.nonAutonomous
        nonAutonomous ∧
      Efficient economy zAI AIMode.nonAutonomous nonAutonomous ∧
      LaborIncomeMaximizing economy zAI nonAutonomous ∧
      nonAutonomous.rentalRate = 0 ∧
      (zAI ≤ pre.wage 0 →
        nonAutonomous.humanWorkersByAI = ∅ ∧
          SameHumanOccupations nonAutonomous pre ∧
          Set.EqOn nonAutonomous.wage pre.wage knowledgeDomain) ∧
      (pre.wage 0 < zAI →
        LiesBelow nonAutonomous.humanWorkersByAI
          (nonAutonomous.humanWorkersByPeople ∪
            nonAutonomous.independent ∪
            nonAutonomous.humanSolversForPeople) ∧
        nonAutonomous.humanWorkersByAI.Nonempty ∧
        nonAutonomous.humanWorkersByPeople.Nonempty ∧
        nonAutonomous.humanSolversForPeople.Nonempty) ∧
      totalOutput economy zAI nonAutonomous <
        totalOutput economy zAI autonomous ∧
      (∃ z ∈ Set.Ioc (0 : ℝ) 1,
        nonAutonomous.wage z ≤ pre.wage z ∧
          (pre.wage 0 < zAI → nonAutonomous.wage z < pre.wage z)) ∧
      (∃ ε > 0,
        ∀ z ∈ Set.Ico (0 : ℝ) ε,
          max (pre.wage z) (autonomous.wage z) ≤
              nonAutonomous.wage z ∧
            (pre.wage 0 < zAI →
              max (pre.wage z) (autonomous.wage z) <
                nonAutonomous.wage z)) ∧
      ∃ ε > 0,
        ∀ z ∈ Set.Ioc (1 - ε) 1,
          nonAutonomous.wage z ≤ autonomous.wage z ∧
            (z ≠ 1 → nonAutonomous.wage z < autonomous.wage z)

end IT25KnowledgeEconomy
