#!/bin/bash
#

_print_colour() {
	printf "\x1b[38;5;${1}m%-12s\x1b[0m" "$2"

}

_print() {
	local n=$1
	local w=$2
	[ $(((n)%w)) -eq 0 ] && printf "% 4d: " "$n"
	_print_colour "$n" "colour${n}"
	[ $(((n+1)%w)) -eq 0 ] && echo
}

i=0
echo
printf "% 4s: " "-"
for c in black red green yellow blue magenta cyan white
do
	_print_colour "$i" "$c"
	i=$((i+1))
done
echo

for i in {0..15}; do _print $i 8 ; done
for i in {16..231}; do _print $i 6 ; done
echo
echo
for i in {232..255}; do _print $i 8; done
echo
