#!/bin/bash
set -u
SP=/usr/lib/python3.11/site-packages/jmcomic
echo '=== grep data_original usage ==='
grep -rn 'data_original' $SP/jm_entity.py $SP/jm_client*.py $SP/jm_downloader.py 2>/dev/null | head -25
echo; echo '=== JmImageDetail.of source ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; print(inspect.getsource(jmcomic.JmImageDetail.of))" 2>&1 | head -40
echo; echo '=== photo get_img_data_original / query params ==='
sudo -n docker exec holy-web python3 -c "import jmcomic, inspect; from jmcomic import JmPhotoDetail; print(inspect.getsource(JmPhotoDetail.get_img_data_original)); print('---'); print(inspect.getsource(JmPhotoDetail.get_data_original_query_params))" 2>&1 | head -60