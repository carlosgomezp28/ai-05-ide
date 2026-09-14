# Extension — intermediate AI autonomy

## Status: proposed extension, not a result of the paper

Ide and Talamàs compare two polar technologies. Autonomous AI can pursue production opportunities as a co-worker or independent producer and can provide advice as a co-pilot. Non-autonomous AI can only provide advice. The paper notes that real applications lie between these extremes, but neither the main paper nor the supplied online appendix directly models a continuous degree of autonomy. The appendix instead studies dimensions such as compute scarcity, superintelligent AI, multiple technologies, unemployment, and additional organizational layers.

This note proposes making intermediate autonomy an explicit primitive. Everything below is a research design and set of conjectures, not a theorem or quantitative result from the paper.

## A separate autonomy primitive

Retain the paper's capability parameter

\[
z_{\mathrm{AI}}\in[0,1),
\]

which determines which problem difficulties AI can solve. Introduce a second parameter

\[
\alpha\in[0,1],
\]

which indexes the set of production opportunities an AI agent is permitted or technically able to pursue without a human directing it. Let $\mathcal P$ be the set of production opportunities and let $\mathcal P_\alpha\subseteq\mathcal P$ be the opportunities open to autonomous AI action. Require

\[
\mathcal P_0=\varnothing,\qquad
\mathcal P_1=\mathcal P,\qquad
\alpha<\alpha'\Longrightarrow\mathcal P_\alpha\subseteq\mathcal P_{\alpha'}.
\]

If a cardinal interpretation is useful, normalize the measure of opportunities so that $\lambda(\mathcal P)=1$ and set $\lambda(\mathcal P_\alpha)=\alpha$. This is a permission constraint, not a probability that an opportunity randomly arrives. Firms may choose any action permitted at a given $\alpha$ and may leave an opportunity unused. The endpoints reproduce the paper's benchmarks:

\[
\alpha=0 \quad\text{(co-pilot only)},\qquad
\alpha=1 \quad\text{(fully autonomous co-pilot and co-worker)}.
\]

Let $x(p)$ denote the difficulty of opportunity $p\in\mathcal P$. Capability and autonomy jointly determine the feasible independent-production set:

\[
\mathcal F(\alpha,z_{\mathrm{AI}})
=\{p\in\mathcal P_\alpha:x(p)\le z_{\mathrm{AI}}\}.
\]

This formulation matters because permission sets of equal measure need not be economically equivalent. Permission to handle routine opportunities and permission to handle difficult opportunities interact differently with capability. AI remains able to advise humans on problems up to $z_{\mathrm{AI}}$ for every $\alpha$; the parameter $\alpha$ changes its feasible autonomous actions, not its knowledge.

## Economic mechanism

Intermediate autonomy changes both the feasible organization set and AI's opportunity cost.

1. **Production option.** As $\alpha$ rises, AI can initiate or execute work on a larger permission set. Single-layer automated production and AI-worker firms become feasible for more opportunities.
2. **Compute price.** The independent-production outside option has no feasible project at the non-autonomous endpoint and recovers the paper's autonomous outside option at $\alpha=1$. At intermediate values, its equilibrium value depends on which newly permitted opportunities firms actually choose and on whether compute is left idle.
3. **Conjectured wage channel at the bottom.** Greater autonomy makes AI a stronger competitor for routine production work. This may reduce the gains of low-knowledge humans who valued AI primarily as a cheap solver.
4. **Conjectured wage channel at the top.** Greater autonomy supplies high-knowledge solvers with scalable AI workers and lets their expertise be applied across more production. This may shift gains toward the top.
5. **Matching and shares.** Changing $\alpha$ reallocates workers and solvers, so wages still combine the paper's match and share effects. A direct wage effect cannot be inferred from the expansion of the feasible set alone.

## Expected comparative statics

One output comparison follows mechanically from nested feasibility. The price and distributional comparisons remain conjectures requiring an equilibrium proof.

- **Mechanical feasible-set implication:** efficient aggregate output is weakly increasing in $\alpha$, because every allocation feasible under $\alpha$ remains feasible under any $\alpha'>\alpha$. Strict inequality additionally requires a newly permitted action to be valuable and the autonomy constraint to bind.
- **Rental-rate conjecture:** the rental rate of compute tends to rise with $\alpha$ as its production outside option expands, but it can remain zero when compute is idle.
- **Bottom-wage conjecture:** humans near the bottom tend to do best at low autonomy when the co-pilot channel dominates and AI does not compete for their production role. Global monotonicity is not guaranteed because matching can improve or deteriorate.
- **Top-wage conjecture:** humans near the top tend to gain as additional autonomous AI workers expand solver leverage. The endpoint comparison in Proposition 6 motivates this conjecture but does not prove monotonicity for intermediate $\alpha$.
- **Threshold conjecture:** an intermediate-autonomy analogue of the bottom-winner cutoff may be a function $\bar z_{\mathrm{AI}}(\alpha)$. Its existence, uniqueness, and slope are open questions. It must not be identified with the paper's separate non-autonomous adoption condition $z_{\mathrm{AI}}>w(0)$.

## Why this cleanly separates capability and autonomy

The extended equilibrium wage can be written as

\[
w(z;z_{\mathrm{AI}},\alpha).
\]

Holding $\alpha$ fixed and varying $z_{\mathrm{AI}}$ asks what happens when AI knows more. Holding $z_{\mathrm{AI}}$ fixed and varying $\alpha$ asks what happens when the same AI is permitted to act on more work. The resulting two-dimensional policy surface separates restrictions on what AI can do independently from investments that improve what AI knows.

## Tractable first step

Before returning to the paper's continuum of human knowledge, solve a two- or three-type version. For each $(z_{\mathrm{AI}},\alpha)$, enumerate feasible one- and two-layer organizations, impose zero profit and market clearing, and compare occupational assignments, output, and wages. That exercise can reveal where equilibrium regimes change and which monotonicity claims are plausible. It would guide, but not replace, a proof in the continuum model.
