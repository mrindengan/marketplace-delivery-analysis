# AI Log

Date: 2026-10-17

- 2026-10-17: Asked Claude Code to run check_connection.py and explain the VS Code notice about python.terminal.useEnvFile. The connection succeeded; I left the setting off.
- 2026-10-19: Asked Claude to challenge my Step 1 decisions and compile D-01 to D-05 from my chat answers (compiled by AI from my words; I confirmed each item). Learned: the two stages of a delivery, overlapping causes, how the promised date can be gamed, scenario vs forecast. Changed: dropped "never" as my change-my-mind condition and wrote the Indonesia item as "reference".
- 2026-10-19: Asked Claude to draft docs/brief.md from D-01 to D-05 (AI-drafted), and to review my persona sentences. Learned: my first persona wording contradicted D-02 (delivery time vs late rate) and named Olist as a real employer. Changed: persona now says late rate and "a marketplace like Olist"; cut my third sentence; added a "provisional" status note.
- 2026-10-19: Asked Claude Code to commit the brief, decisions and CLAUDE.md, then remove "Co-Authored-By: Claude" lines from past commits (backup branch and bundle first, rewrote main only, verified no file changes, force-pushed). Also set empty commit/PR attribution in .claude/settings.local.json and git-ignored it. Learned: rewriting with --all would also rewrite the backup branch and remote-tracking refs. Changed: rewrote refs/heads/main only.
- 2026-10-20: Asked Claude Code to commit the .gitignore and CLAUDE.md changes and find out why Claude still shows as a contributor. Learned: GitHub's contributors API already lists only me; the sidebar is a cache, and old commits stay reachable by ID until GitHub runs garbage collection. Next: ask GitHub Support to run gc on the repo.
