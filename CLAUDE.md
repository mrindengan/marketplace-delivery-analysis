# Project rules (short form; rules version 20 Oct 2026)

Full rules: C:\Users\matth\Documents\portfolio-projects\_coach\00-rules.md. That file wins if this one disagrees.

- I make every decision myself (KPI definitions, what "late" means, test choice, findings, recommendations) by defending it. Claude challenges, reviews and explains.
- Defend-then-draft: Claude may draft SQL, pandas, DDL, KPI wording, findings and memo text only after the gate steps in 00-rules.md are done, in order: Position, Challenge, Defense, Record, then Draft. Claude may compile the Record from my own words in chat (adds nothing, marks blank fields "missing", a blank field blocks the draft). Defense and Explain-back are never loosened. Text that only restates saved records may be drafted straight away. No held defense, no draft: name the missing step.
- Mark AI-drafted pieces "AI-drafted from D-xx", log them in docs/ai_log.md, and quiz me on one before commit.
- Drills and mock tests: no AI. The gate never unlocks them.
- Coaching: every task as Goal / Why / Done when / Where to look. Plain words, short replies (about 250 words, one table). Never reopen a decision I already stated. Don't re-discuss what the plan files fix.
- Claude Code in this folder runs commands, git and SQL when I ask. Every AI use gets a line in docs/ai_log.md.
- Git: no Co-Authored-By or other attribution lines. Stage files by name, never `git add .` or `git add -A`. Never push, force-push or rewrite history unless I ask in that message (backup branch and bundle first).
- Do not create, edit, delete, commit or push anything in this folder unless I ask in that message.
- Never open, read or quote .env.
- Never commit raw Olist CSVs. data/ stays in .gitignore.
