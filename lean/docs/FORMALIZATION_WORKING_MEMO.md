# Formalization Working Memo: Artificial Intelligence in the Knowledge Economy

This is a working lead log, not audit evidence and not a final validation
report. Record possible issues while reading and proving; independently verify
each retained item against the pinned source and final Lean surface during
closeout.

For every item, record the exact source location, current mathematical reading,
Lean treatment, and review state. Prefer “clarification” unless the printed
formula or statement is actually false.

## Possible Source Clarifications

- `source.pdf` and `source-audited.txt` are exact extracts of
  arXiv:2312.05481v11 (SHA-256
  `0b3c727a204f7801a9598dacd7ca7fdb385e21ee6877992ea0eb13c0538d8ebf`
  and `3a773d36805bf40b90d99e18cb7ee6dd8d7a0218f2f7013173d9b577a092eb70`).
- The arXiv v11 source archive contains the 35-page main article but no
  Online Appendix body. The separately downloaded authors' Online Appendix is
  retained only as private proof guidance and is not part of the v11 coverage
  denominator or statement evidence.
- At `source-audited.txt:1375`, `Proposition 6.20` is a PDF-text extraction
  collision: the prose says “Proposition 6” and the following superscript
  footnote marker is 20. It is not a seventh proposition.

## Possible Printed Typos Or Errors

- None recorded.

## Possible Proof-Strategy Deviations

- The source supplies the six proposition statements in the pinned main text,
  while detailed proofs are referred to an external Online Appendix. The
  current contribution therefore stops honestly at a complete statement and
  model layer with six explicit analytical proof obligations.

## Possible Model Conventions Or Extra Assumptions

- Matching and employee matching are total Lean functions because structure
  fields must have total types. `EquilibriumEquivalent` compares them only on
  their source domains (`W_p` and `S_p`), so irrelevant off-domain values do
  not create spurious non-uniqueness.
- `ComputeAbundant` records the source's economic consequence—positive
  autonomous independent compute or positive idle non-autonomous compute—and
  `UniformlyComputeAbundant` makes explicit the paper's statement that a
  finite stock can satisfy abundance for every `zAI ∈ [0,1)`.
- No additional proposition-valued assumptions are declared in
  `Assumptions.lean`; all maintained model primitives are fields of `Economy`.

## Deferred Formalization Or Library Work

- Full proofs of Propositions 1–6 require the continuum matching/equilibrium
  construction, uniqueness, welfare arguments, and wage comparative statics.
  These remain visible `sorry` obligations in `MainTheorems.lean`; none has
  been replaced by a certificate, axiom, or result-bearing structure field.
- The authoritative `lake build +IT25KnowledgeEconomy` completed successfully
  on 2026-09-13 (2,501 jobs) with exactly those six warnings and no additional
  Lean errors. Its paper-module build products postdate the corresponding Lean
  sources, so no rebuild is pending.
- `paper_contribution.py check --fast IT25KnowledgeEconomy` also completed
  successfully: the focused `PaperInterface` build, semantic import-isolation
  check, and scoped diff check all passed.
- The required draft semantic preflight refused its first bounded batch with:
  `Lean could not produce the bounded draft semantic review surface for
  proposition1Spec, proposition2Spec, proposition3Spec, proposition4Spec`
  (fully qualified in the command output). This is an unresolved tooling
  refusal and supplies no positive or negative semantic-review evidence.
- Closeout diagnosis reports that the repository formalization-engine runtime
  differs from its registered revision and requires an append-only registered
  engine-transition commit before planning can continue. That transition spans
  engine/library state outside this paper contribution; it was not modified or
  committed merely to force acceptance.
- The remaining non-accepting audit commands were exercised once without
  manufacturing their prerequisite receipts:
  - conclusion provenance failed closed because no current immutable
    source-record evidence transaction was selectable;
  - assumption provenance failed closed because the saved source-record audit
    is missing or unreadable;
  - the statement and paper-coverage gates each reported a 300-second Lean
    declaration-inventory timeout for `IT25KnowledgeEconomy.PaperInterface`,
    with zero inventory records;
  - the source-to-Lean gate emitted no verdict and did not terminate after the
    same extended inventory window; its stale worker was stopped and must not
    be treated as a pass;
  - the earlier evidence-integrity check remains failed closed because there is
    no current standalone Lean import-closure receipt or retained source-route
    surface; the dashboard also correctly retains zero of six human reviews.
- Consequently the planner-issued evidence graph, source/Spec review receipts,
  final adversarial audit, final validation report, and dependency DAG are not
  eligible for generation. Their absence is intentional and must not be filled
  with hand-authored substitutes.
