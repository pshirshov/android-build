#!/usr/bin/env bash

DST_ARCH="`pwd`/archive"
TGT_DEV=redfin

PREV_BUILD_NUMBER=`ls $DST_ARCH | sed 's/release-'$TGT_DEV'-//g'|sort -r | head -n 1`

rm -rf ./ota
mkdir ./ota

cp $DST_ARCH/release-$TGT_DEV-$PREV_BUILD_NUMBER/*ota_update* ./ota
cp $DST_ARCH/release-$TGT_DEV-$PREV_BUILD_NUMBER/*incremental* ./ota

cp $DST_ARCH/release-$TGT_DEV-$PREV_BUILD_NUMBER/$TGT_DEV-testing ./ota/$TGT_DEV-stable
cp $DST_ARCH/release-$TGT_DEV-$PREV_BUILD_NUMBER/$TGT_DEV-testing ./ota/$TGT_DEV-beta

date > ./ota/$TGT_DEV-stable-changelog.html
date > ./ota/$TGT_DEV-beta-changelog.html

rsync -zvhr --delete ./ota/ root@vm:/srv/ssd/lxd/custom/default_nginx-www/ota.7mind.io/

rm -rf ./ota
