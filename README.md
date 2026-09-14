# Repository 5 — Ide & Talamàs (2025)

*Artificial Intelligence in the Knowledge Economy*
[arXiv:2312.05481v11](https://arxiv.org/abs/2312.05481v11)

**Version read:** arXiv v11, February 25, 2025, 35 pages.

## Research question

How does scalable AI that can acquire tacit knowledge reorganize knowledge work, and who gains when AI can act autonomously rather than only advise humans? The paper embeds AI in a competitive knowledge hierarchy: less knowledgeable people do routine production as workers, while more knowledgeable people solve the exceptional problems workers cannot handle.

## Economic problem and primitives

Humans have observable knowledge $z\in[0,1]$, distributed by a CDF $G$ with continuous, strictly positive density. A production opportunity has difficulty $x\sim U[0,1]$, so an independent producer with knowledge $z$ succeeds with probability $z$. A worker may ask a solver for help; each request costs $h\in(0,1)$ units of solver time. Because a worker fails with probability $1-z$, one solver can support

\[
n(z)=\frac{1}{h(1-z)}
\]

workers. Competitive firms have at most two layers, earn zero profit, choose among independent production and human/AI worker–solver configurations, and must clear the human and compute markets. The AI technology converts one unit of an exogenous compute stock $\mu$ into an agent with knowledge $z_{\mathrm{AI}}\in[0,1)$. The main comparisons assume compute is abundant relative to human time and maintain $h<h_0$, the regime with no independent human producers before AI.

The two AI dimensions are distinct:

- **Capability $z_{\mathrm{AI}}$:** the fraction of problem difficulties the AI can solve; “basic” and “advanced” mean $z_{\mathrm{AI}}\in\operatorname{int}W$ and $z_{\mathrm{AI}}\in\operatorname{int}S$, respectively, relative to the endogenous pre-AI worker and solver sets.
- **Autonomy:** the roles AI is allowed to perform. Autonomous AI can pursue production as an independent producer or worker and can advise as a solver/co-pilot. Non-autonomous AI can only advise. Thus capability is not autonomy.

## Results

Propositions 1–4 provide the setup. The pre-AI equilibrium is unique and efficient, is occupationally stratified $W\preceq I\preceq S$, and has positive assortative matching. With autonomous AI the equilibrium remains unique and efficient, AI always performs some independent production, $r^*=z_{\mathrm{AI}}$, and $W^*\preceq\{z_{\mathrm{AI}}\}\preceq S^*$. Basic AI moves marginal humans from routine work into solving, $W^*\subset W$ and $S\subset S^*$; advanced AI produces the reverse displacement. These reallocations also change worker productivity and solver spans of control.

**Proposition 5 — autonomous AI and the distribution of winners.** Define

\[
B=\{z\in[0,z_{\mathrm{AI}}]:w^*(z)>w(z)\},\qquad
T=\{z\in[z_{\mathrm{AI}},1]:w^*(z)>w(z)\}.
\]

Under $h<h_0$, competitive pre- and post-AI equilibria, $z_{\mathrm{AI}}\in[0,1)$, and compute abundance uniformly over admissible AI capabilities, there is a cutoff

\[
\bar z_{\mathrm{AI}}\in\operatorname{int}W
\quad\text{such that}\quad
B\neq\varnothing\iff z_{\mathrm{AI}}>\bar z_{\mathrm{AI}},
\qquad T\neq\varnothing\ \text{for every }z_{\mathrm{AI}}\in[0,1).
\]

At the bottom, a negative **match effect** (a worse solver) competes with a positive **share effect** (the worker captures more team output); the share effect wins only above the capability cutoff. At the top, the share effect always dominates under the maintained conditions. This is a threshold in **capability**, not autonomy.

**Proposition 6 — non-autonomous AI.** Under $h<h_0$, admissible $z_{\mathrm{AI}}$, abundant compute, and the corresponding pre-AI and autonomous-AI equilibria, the non-autonomous equilibrium is unique, efficient, maximizes labor income, and has $r^N=0$ because some compute is idle. Its adoption condition is different from Proposition 5:

\[
z_{\mathrm{AI}}\le w(0)\Rightarrow\text{AI is unused and wages/occupations equal pre-AI},
\]
\[
z_{\mathrm{AI}}>w(0)\Rightarrow\text{the least knowledgeable humans adopt AI as a solver}.
\]

For any admissible capability, autonomous AI produces strictly more output than non-autonomous AI. A sufficiently low-knowledge interval weakly prefers non-autonomous AI to both no AI and autonomous AI (strictly when $z_{\mathrm{AI}}>w(0)$); a sufficiently high-knowledge interval weakly prefers autonomous AI, with strict inequality away from $z=1$. Therefore $z_{\mathrm{AI}}>\bar z_{\mathrm{AI}}$ is the autonomous-AI **bottom-winner** condition, whereas $z_{\mathrm{AI}}>w(0)$ is the non-autonomous-AI **adoption** condition.

## Lean formalization

The supplied AppliedModelingLib run is **partially formalized**. Its authoritative build and focused interface check succeeded, and `lean/PaperInterface.lean` contains six transparent source-facing Specs, one for each numbered proposition. However, `lean/MainTheorems.lean` contains six unresolved theorem bodies using `sorry`. The successful build shows that the definitions and statements elaborate/typecheck while `sorry` is permitted; it does **not** prove Propositions 1--6. Accepting closeout is additionally blocked outside this paper contribution because the AppliedModelingLib planner requires an append-only registered formalization-engine transition involving external repository engine state.
