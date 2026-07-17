#!/usr/bin/env bash
# test.sh — canonical self-test for skillfind (isolated, no side effects on real catalog).
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
fails=0
chk(){ if eval "$2"; then echo "OK: $1"; else echo "FAIL: $1"; fails=1; fi; }

# syntax
chk "syntax bin/skillfind" "bash -n '$REPO_DIR/bin/skillfind'"
chk "syntax install.sh"     "bash -n '$REPO_DIR/install.sh'"

# fixture skills tree
mkdir -p "$TMP/skills/blockchain/evm" "$TMP/skills/research/arxiv"
printf -- '---\nname: evm\ndescription: Read-only EVM client.\n---\n'   > "$TMP/skills/blockchain/evm/SKILL.md"
printf -- '---\nname: arxiv\ndescription: Search arXiv papers.\n---\n'  > "$TMP/skills/research/arxiv/SKILL.md"

export PREFIX="$TMP" SKILLS_ROOT="$TMP/skills" SKILL_DB="$TMP/cat.db"
chk "install"      "'$REPO_DIR/install.sh' >/dev/null 2>&1"
SF="$TMP/bin/skillfind"
chk "search"       "'$SF' arxiv | grep -q arxiv"
chk "category -c"  "'$SF' -c blockchain | grep -q evm"
chk "list -l"      "'$SF' -l | grep -q blockchain"
chk "usage guard"  "! '$SF' >/dev/null 2>&1"

[[ $fails -eq 0 ]] && echo "ALL PASS" || { echo "FAILURES"; exit 1; }
