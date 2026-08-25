#!/bin/bash
set -u
sudo -n docker exec -i holy-web python3 -u - <<'PY' 2>&1 | tail -30
import jmcomic
from jmcomic.jm_client_impl import JmHtmlClient
opt = jmcomic.create_option_by_file('/app/option.yml')
client = opt.new_jm_client(impl=JmHtmlClient)
print('client:', type(client).__name__)
album = client.get_album_detail('422866')
pages = album.pages
print('pages:', len(pages))
page0 = pages[0]
imgs = page0.images
print('page0 images:', len(imgs))
if imgs:
    im0 = imgs[0]
    print('img0 filename:', im0.filename)
    print('img0 url:', im0.download_url)
    data = client.get_jm_image(im0)
    print('img0 bytes:', len(data) if hasattr(data, '__len__') else type(data))
print('DONE')
PY