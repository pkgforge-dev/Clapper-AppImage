#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q clapper | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/com.github.rafostar.Clapper.svg
export DESKTOP=/usr/share/applications/com.github.rafostar.Clapper.desktop
export DEPLOY_OPENGL=1
export DEPLOY_GSTREAMER=1
export STARTUPWMCLASS=com.github.rafostar.Clapper # Default to Wayland's wmclass. For X11, GTK_CLASS_FIX will force the wmclass to be the Wayland one.
export GTK_CLASS_FIX=1

sys_clapper_dir=$(echo /usr/lib/clapper-*)
if [ -d "$sys_clapper_dir" ]; then
	export PATH_MAPPING="
		$sys_clapper_dir:\${SHARUN_DIR}/lib/${sys_clapper_dir##*/}
	"
else
	>&2 echo "ERROR: Cannot find the clapper lib dir"
	exit 1
fi

# Trace and deploy all files and directories needed for the application (including binaries, libraries and others)
quick-sharun /usr/bin/clapper -- https://test-videos.co.uk/vids/bigbuckbunny/mp4/h265/1080/Big_Buck_Bunny_1080_10s_1MB.mp4

# Turn AppDir into AppImage
quick-sharun --make-appimage
