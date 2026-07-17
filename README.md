# skillfind

Fast full-text search over your local agent **skills catalog** — CLI tool backed by SQLite FTS5.

Scans a skills directory (default `~/.hermes/skills`) for `SKILL.md` files, parses
`name` / `description` / `category` from the YAML frontmatter, and builds a searchable
SQLite database with a full-text index. Query it instantly from the terminal.

## Install

```bash
git clone https://github.com/<user>/skillfind.git
cd skillfind
./install.sh
```

Installs `skillfind` to `$HOME/bin` (override with `PREFIX=/usr/local`) and builds the
catalog. Ensure `$HOME/bin` is on your `PATH`.

### Requirements
- `python3`, `sqlite3`
- `PyYAML` (optional — improves parsing of multi-line descriptions): `pip install pyyaml`

## Usage

```bash
skillfind <query>          # full-text search (name/description/category)
skillfind -c <category>    # list all skills in a category
skillfind -l               # list all categories with counts
skillfind -r               # rebuild the catalog from the skills directory
```

Examples:

```bash
skillfind protein
skillfind -c blockchain
skillfind -l
```

The catalog is auto-built on first run if missing.

## Configuration

Environment variables:

| Var           | Default              | Meaning                          |
|---------------|----------------------|----------------------------------|
| `SKILL_DB`    | `~/skills-catalog.db`| SQLite catalog path              |
| `SKILLS_ROOT` | `~/.hermes/skills`   | Directory scanned for `SKILL.md` |

Rebuild after installing/removing skills:

```bash
skillfind -r
```

## How it works

`SKILL.md` frontmatter → parsed (`name`, `description`, `category` from the top-level
folder) → stored in a `skills` table + an `skills_fts` FTS5 virtual table. Queries hit
the FTS index; `-c`/`-l` hit the plain table.

## License

MIT
