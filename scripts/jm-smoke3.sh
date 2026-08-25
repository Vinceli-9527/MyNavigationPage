#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -70
import jmcomic
opt = jmcomic.create_option_by_file('/app/option.yml')
client = opt.new_jm_client()
album = client.get_album_detail('422866')
print('album type:', type(album).__name__)
print('__dict__ keys:', list(album.__dict__.keys()))
print('has pages:', hasattr(album, 'pages'), '->', getattr(album, 'pages', None))
print('count:', getattr(album, 'count', None), 'index:', getattr(album, 'index', None), 'id:', getattr(album, 'id', None))
print('props:', album.get_properties_dict() if hasattr(album, 'get_properties_dict') else 'n/a')
print()
pd = client.get_photo_detail('422866')
print('photo type:', type(pd).__name__, 'id:', getattr(pd, 'id', None), 'album_index:', getattr(pd, 'album_index', None))
imgs = getattr(pd, 'images', [])
print('photo images:', len(imgs))
if imgs:
    im0 = imgs[0]
    print('img0:', getattr(im0, 'filename', None), getattr(im0, 'download_url', None))
    data = client.get_jm_image(im0)
    print('img bytes:', len(data) if hasattr(data, '__len__') else type(data))
print('DONE')
PY