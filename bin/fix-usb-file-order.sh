#!/bin/sh -e

IN=/media/louie/MAE
TMP="/var/flash_directory/usb"
TMP_OLD=$TMP.old

f_prepare() {
	[ -d "$TMP" ] && mv -v $TMP $TMP_OLD || true
	mkdir -p $TMP

	echo "Move all: $IN -> $TMP"
	mv $IN/* "$TMP/"
}


f_handle() {
	while read f
	do
		if [ -d "$f" ]
		then
			[ "$ret" = "true" ] && echo || true
			ret=false
			mkdir -v "$IN/$f"
		else
			echo -n "."
			ret=true
			mv "$f" "$IN/$f"
		fi
	done
}

f_prepare
cd $TMP
find | grep -v '^\.$' | sort | f_handle
find -type d -delete
