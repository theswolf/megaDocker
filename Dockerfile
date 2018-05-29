FROM ubuntu:18.04
MAINTAINER Christian Geymonat chris.geymo@gmail.com

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y build-essential autoconf automake m4 libtool libtool-bin qt4-qmake make libqt4-dev libcrypto++-dev libsqlite3-dev libc-ares-dev libcurl4-openssl-dev libssl-dev git curl wget sudo pkg-config gcc g++ unzip 

# Optional, if you wish to build nautilus extension:
#sudo apt-get install libnautilus-extension-dev

WORKDIR /opt/
RUN git clone --recursive https://github.com/meganz/MEGAsync.git

WORKDIR /opt/MEGAsync/src
RUN ./configure
RUN qmake MEGA.pro
RUN lrelease MEGASync/MEGASync.pro
RUN make


RUN adduser --disabled-password --gecos '' developer
RUN adduser developer sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER developer

WORKDIR /home/developer

CMD /opt/MEGAsync/src/MEGASync/megasync

#docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw"
#QT_GRAPHICSSYSTEM="native" docker run --rm -it --privileged -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix  -v /home/christian/synced:/home/developer 61d59c27928d
#/opt/MEGAsync/src/MEGASync/megasync
