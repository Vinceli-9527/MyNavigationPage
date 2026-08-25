#!/bin/bash
set -u
echo '=== jmcomic version & exports ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; print(jmcomic.__version__ if hasattr(jmcomic,'__version__') else 'n/a'); print([x for x in dir(jmcomic) if not x.startswith('_')])"
echo; echo '=== get_image_urls / get_album / download signatures ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; [print(n, inspect.signature(getattr(jmcomic,n))) for n in ('get_album','get_image_urls','download_album','create_option_by_file') if hasattr(jmcomic,n)]"
echo; echo '=== JmAlbumDetail / JmPageDetail / JmImageDetail members ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; from jmcomic import JmAlbumDetail, JmPageDetail, JmImageDetail; print('AlbumDetail:', [x for x in dir(JmAlbumDetail) if not x.startswith('_')]); print('PageDetail:', [x for x in dir(JmPageDetail) if not x.startswith('_')]); print('ImageDetail:', [x for x in dir(JmImageDetail) if not x.startswith('_')])"
echo; echo '=== get_image_urls source ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; print(inspect.getsource(jmcomic.get_image_urls))" 2>&1 | head -40