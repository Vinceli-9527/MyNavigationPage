#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -80
import jmcomic, inspect
print('JmOption client methods:', [m for m in dir(jmcomic.JmOption) if 'client' in m.lower() or 'download' in m.lower()])
print('new_jm_client sig:', inspect.signature(jmcomic.JmOption.new_jm_client))
print()
import jmcomic.jm_client_impl as impl
print('jm_client_impl:', [x for x in dir(impl) if not x.startswith('_')])
print()
print('ConfigTemplate:', [x for x in dir(jmcomic.ConfigTemplate) if not x.startswith('_')])
print()
try:
    opt = jmcomic.create_option_by_str(jmcomic.ConfigTemplate.DEFAULT)
    print('default option ok:', type(opt))
    client = opt.new_jm_client()
    print('client:', type(client))
    album = client.get_album_detail('357202')
    print('album OK:', getattr(album,'title',None), 'pages:', len(getattr(album,'pages',[])))
except Exception as e:
    import traceback; traceback.print_exc(limit=3)
print('DONE')
PY