#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | tail -40
import jmcomic, json
opt = jmcomic.create_option_by_file('/app/option.yml')
client = opt.new_jm_client()
pd = client.get_photo_detail('422866')
print('page_arr len:', len(pd.page_arr))
print('page_arr[0]:', json.dumps(pd.page_arr[0], ensure_ascii=False)[:400] if isinstance(pd.page_arr[0], (dict, list)) else pd.page_arr[0])
try:
    client.fetch_photo_additional_field(pd, True, False)
    print('after fetch_additional images:', len(getattr(pd, 'images', [])))
except Exception as e:
    print('fetch_additional error:', type(e).__name__, str(e)[:200])
imgs = getattr(pd, 'images', [])
if not imgs and hasattr(pd, 'create_image_detail'):
    print('trying create_image_detail from page_arr...')
    try:
        imgs = [pd.create_image_detail(x) for x in pd.page_arr]
        print('built images:', len(imgs))
    except Exception as e:
        print('build error:', type(e).__name__, str(e)[:200])
if imgs:
    im0 = imgs[0]
    print('img0:', getattr(im0, 'filename', None), '|', getattr(im0, 'download_url', None))
    data = client.get_jm_image(im0)
    print('bytes:', len(data) if hasattr(data, '__len__') else type(data))
print('DONE')
PY