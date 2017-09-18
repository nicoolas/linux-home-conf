#!/bin/sh


_log() {
	echo "$*"
}

_log
_log "Setting up configuration files"
cd $(dirname $0)
cur_dir=$(pwd)
for file in conf/_.* bin
do
	link_file="$HOME/$(basename $file | sed s/^_//)"
	echo "- $(basename $link_file)"
	if [ -L $link_file ]
	then
		echo "  Remove link: $link_file"
		rm  $link_file
	elif [ -e $link_file ]
	then
		echo -n "  Make backup: "
		mv -v $link_file $link_file.$(date +%Y%m%d_%H%M%S)
	fi
	echo -n "  Make link: "
	ln -sv $cur_dir/$file $link_file
done

_log
bash_share="$HOME/.bash_share"
bash_rc="$HOME/.bashrc"
if grep -q "^[^#].*source $bash_share" $bash_rc
then
	_log "DO NOT duplicate '$bash_share' sourcing in '$bash_rc'"
else
	_log "Appending sources to bashrc file"
	cat >> $bash_rc <<-EOS
	[ -f $bash_share ] && source $bash_share
	EOS
fi

_log

