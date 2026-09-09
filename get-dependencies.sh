#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package and its dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	glib2-devel      \
	graphene         \
	graphviz         \
	gst-plugins-ugly \
	gst-plugins-bad  \
	gst-plugins-base \
	gst-plugins-good \
	gst-libav        \
	gst-plugin-va    \
	gstreamer        \
	libadwaita       \
	libmicrodns      \
	libpeas-2        \
	libsoup3         \
	meson            \
	ninja            \
	pango

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini

echo "Building Clapper..."
echo "---------------------------------------------------------------"
git clone https://github.com/Rafostar/clapper ./clapper && (
	cd ./clapper

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
	git checkout "$TAG"
	echo "$TAG" > ~/version

	git apply ../patches/*.patch

	meson setup build --prefix=/usr --libdir=lib --buildtype=release \
		-D clapper=enabled          \
		-D clapper-gtk=enabled      \
		-D clapper-app=enabled      \
		-D gst-plugin=enabled       \
		-D enhancers-loader=enabled \
		-D discoverer=enabled       \
		-D mpris=enabled            \
		-D server=enabled           \
		-D glimporter=enabled       \
		-D gluploader=enabled       \
		-D rawimporter=enabled      \
		-D introspection=disabled   \
		-D vapi=disabled            \
		-D doc=false

	meson compile -C build
	meson install -C build
)
