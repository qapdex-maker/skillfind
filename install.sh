#!/usr/bin/env bash
# install.sh — installiert skillfind nach $PREFIX/bin und baut den Katalog.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${PREFIX:-$HOME}"
BIN_DIR="$PREFIX/bin"

echo "==> skillfind installer"

# Dependencies pruefen
missing=0
for cmd in python3 sqlite3; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "FEHLT: $cmd"; missing=1; }
done
if [[ $missing -ne 0 ]]; then
  echo "Bitte fehlende Abhaengigkeiten installieren (Termux: pkg install python sqlite)." >&2
  exit 1
fi
python3 -c "import yaml" 2>/dev/null || echo "Hinweis: PyYAML fehlt (optional, verbessert mehrzeilige Descriptions): pip install pyyaml"

# Binary installieren
mkdir -p "$BIN_DIR"
install -m 0755 "$REPO_DIR/bin/skillfind" "$BIN_DIR/skillfind"
echo "==> installiert: $BIN_DIR/skillfind"

# PATH-Hinweis
case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) echo "Hinweis: $BIN_DIR ist nicht im PATH. Ergaenze in ~/.bashrc:"
     echo "    export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac

# Katalog bauen
echo "==> baue Skills-Katalog ..."
"$BIN_DIR/skillfind" -r

echo "==> fertig. Test: skillfind protein"
