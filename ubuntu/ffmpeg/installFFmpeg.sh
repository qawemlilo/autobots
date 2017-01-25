#!/bin/bash

#: Installs FFmpeg for ubuntu
#: Must be run as root.
#: This script was derived from [https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu]
#: 
#: Tested on Ubuntu Server 16.10.
#: Author: Fastily

cd "${0%/*}" &> /dev/null
source ../../shared/autobotUtils.sh
confirmRunAsRoot

## Setting up folder env variables
rootsrc="${HOME}/ffmpeg"
src="${rootsrc}/src"
build="${rootsrc}/build"
bin="${rootsrc}/bin"

## Make the output directories if they don't exist
mkdir -p "$rootsrc" "$src" "$build" "$bin"

##
# Installs ffmpeg
##
installFFmpeg()
{
	cd "$src"
	wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
	tar xjvf ffmpeg-snapshot.tar.bz2
	cd ffmpeg

	PATH="$bin":"$PATH" PKG_CONFIG_PATH="${build}/lib/pkgconfig" ./configure \
	  --prefix="$build" \
	  --pkg-config-flags="--static" \
	  --extra-cflags="-I${build}/include" \
	  --extra-ldflags="-L${build}/lib" \
	  --bindir="$bin" \
	  --enable-gpl \
	  --enable-libass \
	  --enable-libfdk-aac \
	  --enable-libfreetype \
	  --enable-libmp3lame \
	  --enable-libopus \
	  --enable-libtheora \
	  --enable-libvorbis \
	  --enable-libvpx \
	  --enable-libx264 \
	  --enable-nonfree

	PATH="$bin":"$PATH" make
	make install
	make distclean
	hash -r
}

## Install FFmpeg and dependencies
cd ~
apt-get update

apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev yasm libx264-dev libmp3lame-dev libopus-dev libvpx-dev libfdk-aac-dev
 
installFFmpeg


chmod -R a+rx "$rootsrc"
touch ~/.bash_profile
printf "\nPATH=\$PATH:${bin}" >> ~/.profile

printf "All done!\n"
