#!/bin/sh


_log() {
	echo "$*"
}

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

_log "Appending sources to bashrc file"
cat >> $HOME/.bashrc << EOS 
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_share ] && source ~/.bash_share
EOS


