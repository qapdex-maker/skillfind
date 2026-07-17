#!/usr/bin/env bash
# install.sh — install skillfind to $PREFIX/bin and build the catalog.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${PREFIX:-$HOME}"
BIN_DIR="$PREFIX/bin"

echo "==> skillfind installer"

# Check dependencies
missing=0
for cmd in python3 sqlite3; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "MISSING: $cmd"; missing=1; }
done
if [[ $missing -ne 0 ]]; then
  echo "Please install the missing dependencies (Termux: pkg install python sqlite)." >&2
  exit 1
fi
python3 -c "import yaml" 2>/dev/null || echo "Note: PyYAML missing (optional, improves multi-line descriptions): pip install pyyaml"

# Install binary
mkdir -p "$BIN_DIR"
install -m 0755 "$REPO_DIR/bin/skillfind" "$BIN_DIR/skillfind"
echo "==> installed: $BIN_DIR/skillfind"

# PATH hint
case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) echo "Note: $BIN_DIR is not on your PATH. Add to ~/.bashrc:"
     echo "    export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac

# Build catalog
echo "==> building skills catalog ..."
"$BIN_DIR/skillfind" -r

echo "==> done. Try: skillfind protein"
