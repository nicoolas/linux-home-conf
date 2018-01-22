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
sh_share="$HOME/.sh_share"
for shrc in "$HOME/.bashrc" "$HOME/.zshrc"
do
	if grep -q "^[^#].*source $sh_share" $shrc
	then
		_log "DO NOT duplicate '$sh_share' sourcing in '$shrc'"
	else
		_log "Appending sources to file '$shrc'"
		cat >> $shrc <<-EOS
		[ -f $sh_share ] && source $sh_share
		EOS
	fi
done


for old_shrc in "$HOME/.bash_aliases" "$HOME/.bash_share"
do
	[ -L $old_shrc ] && rm  -v $old_shrc
done

# clean old naming
[ -e $HOME/.bash_local ]  && mv -v $HOME/.bash_local $HOME/.sh_local
sed -i '/~\/.bash_aliases/d' $HOME/.bashrc
sed -i '/~\/.bash_share/d' $HOME/.bashrc

_log

