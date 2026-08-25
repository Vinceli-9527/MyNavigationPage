#!/bin/bash
set -u
echo '=== find get_jm_image def ==='
sudo -n docker exec holy-web grep -rn 'def get_jm_image' /usr/lib/python3.11/site-packages/jmcomic/ 2>/dev/null | head
echo '=== source of JmApiClient.get_jm_image ==='
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -50
import jmcomic, inspect
c = jmcomic.JmApiClient
print(inspect.getsource(c.get_jm_image))
PY