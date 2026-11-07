#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest discover -s tests -p 'test_*.py' -v
dotnet run --project tests/weave/WeaveTests.csproj -c Release
dotnet run --project tests/rhythm/RhythmTests.csproj -c Release
for test in tests/*.lua; do
  [[ "$test" == tests/lsp.lua ]] && continue
  nvim --headless -u NONE -l "$test"
done
case "${1:-}" in
  '') ;;
  --lsp) nvim --headless -u NONE -l tests/lsp.lua ;;
  *) echo 'usage: tools/test.sh [--lsp]' >&2; exit 64 ;;
esac
