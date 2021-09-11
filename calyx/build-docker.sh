#!/usr/bin/env -S bash -xe

docker build ./docker -t calyxbuild

mkdir -p $(pwd)/ccache
echo "max_size = 100G" > $(pwd)/ccache/ccache.conf

CALYX_REVISION="a9831bd66ebf881c98ae3d571a3f0cfdca4c7de8"

# mkdir -p os
# pushd .
# cd os
# repo init -u https://gitlab.com/CalyxOS/platform_manifest -b $CALYX_REVISION
# popd

docker run -t --rm \
    --user $(id -u):$(id -g) \
    --mount type=bind,source=$(pwd),destination=/work \
    --mount type=bind,source=$(pwd)/ccache,destination=/var/cache/ccache \
    calyxbuild:latest ./build.sh $*
