#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package and its dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
            clapper \
            gst-plugins-bad \
            gst-libav \
            gst-plugin-va \
            ffmpeg

if [ "$ARCH" = 'x86_64' ]; then
  pacman -Syu --noconfirm libva-intel-driver
fi

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini intel-media-driver
