#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -60
import jmcomic
opt = jmcomic.create_option_by_file('/app/option.yml')
print('option:', type(opt).__name__)
client = opt.new_jm_client()
print('client:', type(client).__name__)
for aid in ['357202', '422866', '56664']:
    try:
        album = client.get_album_detail(aid)
        print('OK', aid, '| title:', getattr(album, 'title', None), '| pages:', len(getattr(album, 'pages', [])))
        pages = getattr(album, 'pages', [])
        if pages:
            imgs = getattr(pages[0], 'images', [])
            print('  page0 images:', len(imgs))
            if imgs:
                im0 = imgs[0]
                print('  url:', getattr(im0, 'download_url', None))
                print('  filename:', getattr(im0, 'filename', None))
                data = client.get_jm_image(im0)
                print('  image bytes:', len(data) if hasattr(data,'__len__') else type(data))
        break
    except Exception as e:
        print('FAIL', aid, '->', type(e).__name__, str(e)[:120])
print('DONE')
PY