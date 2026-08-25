#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -40
import jmcomic, inspect
print('JmImageResp members:', [m for m in dir(jmcomic.JmImageResp) if not m.startswith('_')])
try:
    print(inspect.getsource(jmcomic.JmImageResp))
except Exception as e:
    print('no source:', e)
print('bases:', jmcomic.JmImageResp.__mro__)
PY