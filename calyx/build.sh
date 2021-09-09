#!/usr/bin/env -S bash -xe

TGT_DEV=redfin
LMANIFEST_DIR=`pwd`/manifests
CUSTOM_PACKAGES="CallRecorder"
vendor=calyx

export USE_CCACHE=1
export CCACHE_EXEC=`which ccache`
export OFFICIAL_BUILD=true

DST_DIST="`pwd`/calyx-out"
DST_ARCH="`pwd`/archive"
VENV="`pwd`/p2"

rm -rf $DST_DIST
mkdir $DST_DIST
mkdir -p os

pushd .
cd os
rm -rf .repo/local_manifests/
cp -r $LMANIFEST_DIR/ .repo/local_manifests/

repo forall -vc "git reset --hard"
repo forall -vc "git clean -fxd"
repo sync -d -j 32


mkdir -p "vendor/$vendor/overlay/microg/"
sed -i "1s;^;PRODUCT_PACKAGE_OVERLAYS := vendor/$vendor/overlay/microg\n;" "vendor/$vendor/config/common.mk"
sed -i "1s;^;PRODUCT_PACKAGES += $CUSTOM_PACKAGES\n\n;" "vendor/$vendor/config/common.mk"



#./vendor/calyx/scripts/setup-apv.sh $TGT_DEV

source build/envsetup.sh

sed -i 's/release.calyxinstitute.org/ota.7mind.io/g' packages/apps/Updater/res/values/config.xml
patch -p1 < ../adguard.diff

pushd .
cd ./frameworks/base/
patch -p1 < ../../../backup2.diff
# patch -p1 < ../../../allow-backup.diff
# patch -p1 < ../../../backup3.diff
popd

lunch calyx_$TGT_DEV-user

m installclean
m target-files-package
m otatools-package otatools-keys-package

cp $OUT/otatools.zip $DST_DIST
cp $OUT/obj/PACKAGING/target_files_intermediates/*.zip $DST_DIST
cp $OUT/otatools-keys.zip $DST_DIST

popd

rm -rf $VENV
virtualenv --python=$(which python2) $VENV
source $VENV/bin/activate

pushd .
cd $DST_DIST
ln -s ../keys ./keys


unzip -q ./otatools.zip
#export BUILD_NUMBER=eng.$USERNAME

./vendor/calyx/scripts/release.sh $TGT_DEV $DST_DIST/calyx_$TGT_DEV-target_files-${BUILD_NUMBER}.zip

pushd .
cd $DST_DIST/out/release-$TGT_DEV-${BUILD_NUMBER}/
$DST_DIST/vendor/calyx/scripts/generate_metadata.py $TGT_DEV-ota_update-${BUILD_NUMBER}.zip
#unzip -q redfin-factory-*.zip
popd

PREV_BUILD_NUMBER=`ls $DST_ARCH | sed 's/release-'$TGT_DEV'-//g'|sort -r | head -n 1`
cp -R $DST_DIST/out/release-$TGT_DEV-${BUILD_NUMBER}/ $DST_ARCH/

ln -s $DST_ARCH ./archive
./vendor/calyx/scripts/generate_delta.sh $TGT_DEV ${PREV_BUILD_NUMBER} ${BUILD_NUMBER}

popd

rm -rf $DST_DIST/
deactivate
rm -rf $VENV
