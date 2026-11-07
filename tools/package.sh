#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import hashlib
import json
from pathlib import Path
import subprocess
import tarfile
import zipfile

root = Path.cwd()
manifest = json.loads((root / 'plugin/XivSpell.json').read_text())
version = manifest['AssemblyVersion']
output = root / 'plugin/bin/Release'
required = [output / name for name in ('XivSpell.dll', 'KamiToolKit.dll')]
for path in required:
    if not path.is_file():
        raise SystemExit(f'Missing {path}; build the Release plugin first')
release = root / 'release'
release.mkdir(exist_ok=True)
package = release / f'XivSpell-{version}.zip'
with zipfile.ZipFile(package, 'w', zipfile.ZIP_DEFLATED) as archive:
    for path in required + [root / 'plugin/XivSpell.json']:
        info = zipfile.ZipInfo(path.name, (2026, 1, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        archive.writestr(info, path.read_bytes())
source = release / f'XivSpell-companion-{version}.tar.gz'
tracked = subprocess.check_output(['git', 'ls-files', '-z']).decode().split('\0')
if not any(tracked):
    raise SystemExit('Commit the source before packaging the companion archive')
with tarfile.open(source, 'w:gz') as archive:
    for name in sorted(filter(None, tracked)):
        archive.add(root / name, arcname=f'xivspell/{name}', recursive=False)
checksums = ''.join(f'{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.name}\n'
                    for p in (package, source))
(release / 'SHA256SUMS').write_text(checksums)
print(checksums, end='')
PY
