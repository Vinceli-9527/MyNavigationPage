#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | tail -35
import jmcomic, inspect
opt = jmcomic.create_option_by_file('/app/option.yml')
client = opt.new_jm_client()
print('has fetch_photo_additional_field:', hasattr(client, 'fetch_photo_additional_field'))
if hasattr(client, 'fetch_photo_additional_field'):
    print('sig:', inspect.signature(client.fetch_photo_additional_field))
pd = client.get_photo_detail('422866')
print('after get_photo_detail __dict__:', list(pd.__dict__.keys()))
print('images:', len(getattr(pd, 'images', [])))
try:
    client.fetch_photo_additional_field(pd)
    print('after fetch_additional: images:', len(getattr(pd, 'images', [])))
except Exception as e:
    print('fetch_additional error:', type(e).__name__, str(e)[:150])
imgs = getattr(pd, 'images', [])
if imgs:
    im0 = imgs[0]
    print('img0:', getattr(im0, 'filename', None), '|', getattr(im0, 'download_url', None))
    data = client.get_jm_image(im0)
    print('bytes:', len(data) if hasattr(data, '__len__') else type(data))
print('DONE')
PY