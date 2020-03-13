#!/bin/sh

out_dir="$(pwd)"
http_url_prefix="https://localhost"
#youtube_dl_cmd=$(pwd)/plugins/videodl/youtube-dl
youtube_dl_cmd=/tmp/youtube-dl

if [ "$1" = "audio" ]
then mode="$1"; shift
elif [ "$1" = "video" ]
then mode="$1"; shift
fi

f_failure() {
	echo "Failure: $*"
}

f_fatal() {
	f_failure "$*"
	echo
	exit 1
}

f_print_link() {
    [ -n "$2" ] && extra="($(du -h $out_dir/$2 | cut -f1))"
	echo "$1: $http_url_prefix/$2 $extra"
}

f_do_update_youtube_dl() {
	if [ ! -x $youtube_dl_cmd ]
	then
		curl -L https://yt-dl.org/downloads/latest/youtube-dl -o $youtube_dl_cmd
		chmod a+x $youtube_dl_cmd
	fi
}

if [ "$1" = "clean" ]
then
	[ -z "$out_dir" ] && f_fatal "BUG" # Better be safe
	rm -f $out_dir/*
	echo "Cleaned download directory: $http_url_prefix"
	exit 0
fi
url="$1"

[ -n "$url" ] || f_fatal "Missing url arg"
cd $out_dir || f_fatal "Cannot chdir to $out_dir"

f_do_download() {
	f_do_update_youtube_dl || f_fatal "Failed to update download tool"
    echo "x extra option: $youtube_dl_extra_options"
	echo "x url: '$url'"
	out_dl=$($youtube_dl_cmd --restrict-filenames --get-filename "$url") || return 1
	echo "x out_dl: '$out_dl'"
	out_dl_basename=$(echo $out_dl | sed 's/\.[^\.]*$//')

	# Clean
	[ -z "$out_dl_basename" ] && f_fatal "BUG" # Better be safe
	rm -f $out_dl_basename.*
	$youtube_dl_cmd --restrict-filenames --quiet $youtube_dl_extra_options "$url" >/dev/null || return 1
	# Get actual output video filename
	out_dl=$(ls -1 $out_dl_basename.*)
}
echo "Download Video #1" >&2
if ! f_do_download
then
	echo "Download Video #2" >&2
	rm $youtube_dl_cmd >/dev/null
	f_do_download || f_fatal "Download failed"
fi
[ -r "$out_dl" ] || f_fatal "Something went wrong, see $http_url_prefix"
f_print_link "Download Video" $out_dl

# arg1: name
# arg2: format
f_convert() {
	local format=$2
	local name=$1
	echo "Convert to $name ($format)" >&2
	local out=${out_dl_basename}.$format
	# https://trac.ffmpeg.org/wiki/Encode/MP3
	# -codec:a libmp3lame -qscale:a 2
	ffmpeg -loglevel quiet -i $out_dl $out >/dev/null 
	if [ -f "$out" ]
	then
		f_print_link "Download $name" $out
	else
		f_failure "Failed to convert to $name"
	fi
}

if [ "$mode" != "audio" ]
then
	echo $out_dl | grep -q '\.mp4$' || f_convert "Video" "mp4"
fi
if [ "$mode" != "video" ]
then
	f_convert "Audio" "mp3"
fi

f_print_link "Directory" ""
echo "--- --- ---"

