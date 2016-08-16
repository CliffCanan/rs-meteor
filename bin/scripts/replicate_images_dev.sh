#!/bin/bash

ssh rentscene.prod "tar cf files.tar files/*"

ssh rentscene.dev "scp root@104.131.46.123:files.tar ."
ssh rentscene.dev "rm -rf ~/files"
ssh rentscene.dev "tar xf ~/files.tar"
ssh rentscene.dev "rm -rf /opt/rentscene/cfs/files_old"
ssh rentscene.dev "mv /opt/rentscene/cfs/files /opt/rentscene/cfs/files_old"
ssh rentscene.dev "mv ~/files /opt/rentscene/cfs/"
