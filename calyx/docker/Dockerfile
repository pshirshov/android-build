FROM docker.io/library/ubuntu:hirsute

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get upgrade -y && apt-get install -y bc git curl zip m4 python3-protobuf default-jdk-headless default-jre-headless libncurses5 libncurses5-dev libssl-dev repo ccache rsync virtualenv python2 xxd cgpt && dpkg-reconfigure --frontend noninteractive tzdata

VOLUME /work
VOLUME /var/cache/ccache

WORKDIR /work

ADD config /root/.gitconfig


