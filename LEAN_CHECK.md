# AppliedModelingLib validation

Repository 5 formalization source: `IT25KnowledgeEconomy`

Required validation command, run from the root of AppliedModelingLib:

```bash
python3 scripts/paper_contribution.py check IT25KnowledgeEconomy --fast
```

Result:

```text
+ lake build +IT25KnowledgeEconomy.PaperInterface
Build completed successfully (2498 jobs).
+ git diff --check -- papers/IT25KnowledgeEconomy papers/IT25KnowledgeEconomy.lean lakefile.toml ':(exclude)papers/IT25KnowledgeEconomy/source/'
```

Exit code:

```text
0
```

This validation confirms that the generated paper interface builds and the scoped
diff check passes. It does not imply that Propositions 1–6 are formally proved;
the six theorem bodies remain `sorry`, as recorded in `lean/status.json`.
