#!/bin/bash

#FROM lsiobase/ubuntu:bionic as buildstage

############## build stage ##############

# package versions
#ARG KODI_NAME="Leia"
#ARG KODI_VER="18.5"
KODI_NAME="Leia"
KODI_VER="18.5"

# defines which addons to build
KODI_ADDONS="vfs.libarchive vfs.rar"

# environment settings
DEBIAN_FRONTEND="noninteractive"

# copy patches and excludes
#COPY patches/ /patches/

# install build packages
 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	autoconf \
	automake \
	autopoint \
	binutils \
	cmake \
	curl \
	default-jre \
	g++ \
	gawk \
	gcc \
	git \
	gperf \
	libass-dev \
	libavahi-client-dev \
	libavahi-common-dev \
	libbluray-dev \
	libbz2-dev \
	libcurl4-openssl-dev \
	libegl1-mesa-dev \
	libflac-dev \
	libfmt-dev \
	libfreetype6-dev \
	libfstrcmp-dev \
	libgif-dev \
	libglew-dev \
	libiso9660-dev \
	libjpeg-dev \
	liblcms2-dev \
	liblzo2-dev \
	libmicrohttpd-dev \
	libmysqlclient-dev \
	libnfs-dev \
	libpcre3-dev \
	libplist-dev \
	libsmbclient-dev \
	libsqlite3-dev \
	libssl-dev \
	libtag1-dev \
	libtiff5-dev \
	libtinyxml-dev \
	libtool \
	libvorbis-dev \
	libxrandr-dev \
	libxslt-dev \
	make \
	nasm \
	python-dev \
	rapidjson-dev \
	swig \
	uuid-dev \
	yasm \
	zip \
	zlib1g-dev

# CLONE
cd ~

git clone https://github.com/linuxserver/docker-kodi-headless.git

# fetch source and apply any required patches

 set -ex && \
 mkdir -p \
	~/khead_nodocker/kodi-source/build && \
	cd khead_nodocker
 
curl -o \
 ~/khead_nodocker/kodi.tar.gz -L \
	"https://github.com/xbmc/xbmc/archive/${KODI_VER}-${KODI_NAME}.tar.gz"

 tar xf ~/khead_nodocker/kodi.tar.gz -C \
	~/khead_nodocker/kodi-source --strip-components=1 && \
 cd ~/khead_nodocker/kodi-source && \
 git apply \
	~/docker-kodi-headless/patches/"${KODI_NAME}"/headless.patch

# build package

cd ~/khead_nodocker/kodi-source/build
cmake ../. -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_AIRTUNES=OFF -DENABLE_ALSA=OFF -DENABLE_AVAHI=OFF -DENABLE_BLUETOOTH=OFF -DENABLE_BLURAY=ON -DENABLE_CAP=OFF -DENABLE_CEC=OFF -DENABLE_DBUS=OFF -DENABLE_DVDCSS=OFF -DENABLE_GLX=OFF -DENABLE_INTERNAL_FLATBUFFERS=ON -DENABLE_LIBUSB=OFF -DENABLE_NFS=ON -DENABLE_OPENGL=OFF -DENABLE_OPTICAL=OFF -DENABLE_PULSEAUDIO=OFF -DENABLE_SNDIO=OFF -DENABLE_UDEV=OFF -DENABLE_UPNP=ON -DENABLE_VAAPI=OFF -DENABLE_VDPAU=OFF


#!/bin/bash

#FROM lsiobase/ubuntu:bionic as buildstage

############## build stage ##############

# package versions
#ARG KODI_NAME="Leia"
#ARG KODI_VER="18.5"
KODI_NAME="Leia"
KODI_VER="18.5"

# defines which addons to build
KODI_ADDONS="vfs.libarchive vfs.rar"

# environment settings
DEBIAN_FRONTEND="noninteractive"


### START PART 2
cd ~/khead_nodocker/kodi-source/build
### LAST DIRECTORY P1 WAS IN


 make -j3
 
 make DESTDIR=~/khead_nodocker/kodi-build install

# build kodi addons

 set -ex && \
 cd ~/khead_nodocker/kodi-source && \
 make -j3 \
	-C tools/depends/target/binary-addons \
	ADDONS="$KODI_ADDONS" \
	PREFIX=~/khead_nodocker/kodi-build/usr

# install kodi send

 install -Dm755 \
	~/khead_nodocker/kodi-source/tools/EventClients/Clients/KodiSend/kodi-send.py \
	~/khead_nodocker/kodi-build/usr/bin/kodi-send && \
 install -Dm644 \
	~/khead_nodocker/kodi-source/tools/EventClients/lib/python/xbmcclient.py \
	~/khead_nodocker/kodi-build/usr/lib/python2.7/xbmcclient.py

#FROM lsiobase/ubuntu:bionic

############## runtime stage ##############

# set version label
#ARG BUILD_DATE
#ARG VERSION
#LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
#LABEL maintainer="sparklyballs"

# environment settings
#ARG DEBIAN_FRONTEND="noninteractive"
#ENV HOME="/config"

# install runtime packages

 apt-get update && \
 apt-get install -y \
	--no-install-recommends \
	libass9 \
	libbluray2 \
	libegl1 \
	libfstrcmp0 \
	libgl1 \
	liblcms2-2 \
	liblzo2-2 \
	libmicrohttpd12 \
	libmysqlclient20 \
	libnfs11 \
	libpcrecpp0v5 \
	libpython2.7 \
	libsmbclient \
	libtag1v5 \
	libtinyxml2.6.2v5 \
	libxrandr2 \
	libxslt1.1

# cleanup 

# rm -rf \
	~/khead_nodocker/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy local files and artifacts of build stages.
#COPY root/ /
#COPY --from=buildstage /tmp/kodi-build/usr/ /usr/

cp -r ~/khead_nodocker/kodi-build/usr/* /usr
cp -r ~/docker-kodi-headless/root/defaults/* ~/.kodi/userdata

# ports and volumes
#VOLUME /config/.kodi
#EXPOSE 8080 9090 9777/ud

