#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.rafostar.Clapper.svg
export DESKTOP=/usr/share/applications/com.github.rafostar.Clapper.desktop
export DEPLOY_GSTREAMER=1
export DEPLOY_PYTHON=1
export STARTUPWMCLASS=com.github.rafostar.Clapper # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1
export STRACE_BINARY=clapper
export STRACE_FLAGS=https://test-videos.co.uk/vids/bigbuckbunny/mp4/h265/1080/Big_Buck_Bunny_1080_10s_1MB.mp4
export USE_HOST_DRIVERS_EXPERIMENTAL=1

# Deploy dependencies
clapper_dir=$(echo /usr/lib/clapper*)
quick-sharun /usr/bin/clapper "$clapper_dir" \
             /usr/bin/qjs \
             /usr/lib/libpeas-2/loaders/*

echo "CLAPPER_SINK_IMPORTER_PATH=\${SHARUN_DIR}/lib/${clapper_dir##*/}/gst/plugin/importers" >> ./AppDir/.env
echo "CLAPPER_ENHANCERS_PATH=\${SHARUN_DIR}/lib/${clapper_dir##*/}/enhancers" >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage $STRACE_FLAGS
