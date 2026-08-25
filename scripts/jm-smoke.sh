#!/bin/bash
set -u
echo '=== smoke test jmcomic metadata + one image ==='
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | head -60
import jmcomic
client = jmcomic.JmcomicClient()
for aid in ['357202', '422866', '100001']:
    try:
        album = client.get_album_detail(aid)
        print('OK album', aid, '| title:', getattr(album, 'title', None), '| pages:', len(getattr(album, 'pages', [])))
        pages = getattr(album, 'pages', [])
        if pages:
            p0 = pages[0]
            imgs = getattr(p0, 'images', [])
            print('  first page images:', len(imgs))
            if imgs:
                im0 = imgs[0]
                print('  download_url:', getattr(im0, 'download_url', None))
                print('  filename:', getattr(im0, 'filename', None))
                try:
                    data = client.get_jm_image(im0)
                    print('  get_jm_image ->', type(data).__name__, len(data) if hasattr(data, '__len__') else '')
                except Exception as e:
                    print('  get_jm_image error:', type(e).__name__, str(e)[:150])
        break
    except Exception as e:
        print('FAIL', aid, '->', type(e).__name__, str(e)[:150])
print('DONE')
PY