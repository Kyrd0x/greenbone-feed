#!/bin/bash

rsync -av rsync://feed.community.greenbone.net/community/vulnerability-feed/24.10/scap-data/ vulnerability-feed/scap-data/
rsync -av rsync://feed.community.greenbone.net/community/vulnerability-feed/24.10/cert-data/ vulnerability-feed/cert-data/
rsync -av rsync://feed.community.greenbone.net/community/vulnerability-feed/24.10/vt-data/notus/ vulnerability-feed/vt-data/notus/
rsync -av rsync://feed.community.greenbone.net/community/vulnerability-feed/24.10/vt-data/nasl/ vulnerability-feed/vt-data/nasl/
rsync -av rsync://feed.community.greenbone.net/community/data-feed/24.10/ data-feed/

zip -r greenbone-feed.zip vulnerability-feed/ data-feed/