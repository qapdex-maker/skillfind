# Bolt's Journal - Critical Learnings

## 2025-02-15 - Dynamic SQLite FTS5 Capability Probing
**Learning:** In environments with Android SDKs or minimal platform tools prepended to the system PATH, the standard `sqlite3` CLI executable might resolve to a stripped-down binary that completely lacks FTS5 virtual table support. Hardcoding full paths like `/usr/bin/sqlite3` is an anti-pattern as it overrides modern, custom-installed SQLite versions (such as those from Homebrew) that support formatting options like `-box` (added in 3.33.0).
**Action:** Proactively test sqlite3 candidates by executing a light, in-memory capability probe (`CREATE VIRTUAL TABLE t USING fts5(x);`) to dynamically select the most full-featured, compatible SQLite binary while fully respecting the user's PATH settings.
