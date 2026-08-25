#!/bin/bash
set -u
echo '=== JmcomicClient methods ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; c=jmcomic.JmcomicClient; print([m for m in dir(c) if not m.startswith('_')])"
echo; echo '=== JmApiClient methods ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; c=jmcomic.JmApiClient; print([m for m in dir(c) if not m.startswith('_')])"
echo; echo '=== JmAlbumDetail members ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; c=jmcomic.JmAlbumDetail; print([m for m in dir(c) if not m.startswith('_')])"
echo; echo '=== JmPhotoDetail members ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; c=jmcomic.JmPhotoDetail; print([m for m in dir(c) if not m.startswith('_')])"
echo; echo '=== JmImageDetail members ==='
sudo -n docker exec holy-web python3 -c "import jmcomic; c=jmcomic.JmImageDetail; print([m for m in dir(c) if not m.startswith('_')])"
echo; echo '=== JmcomicClient ctor ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; print(inspect.signature(jmcomic.JmcomicClient.__init__)); print(inspect.signature(jmcomic.JmApiClient.__init__))"
echo; echo '=== how to get album detail (source of new_downloader?) ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; print(inspect.getsource(jmcomic.JmcomicClient.get_album_detail))" 2>&1 | head -30