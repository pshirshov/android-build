#!/usr/bin/env -S bash -xe

docker build ./docker -t calyxbuild

mkdir -p $(pwd)/ccache
echo "max_size = 100G" >$(pwd)/ccache/ccache.conf

docker run -t --rm \
    --mount type=bind,source=$(pwd),destination=/work \
    --mount type=bind,source=$(pwd)/ccache,destination=/var/cache/ccache \
    calyxbuild:latest ./build.sh $*
