#!/bin/sh

dir=$(realpath $(dirname $(realpath $0)))
echo "Change Dir to $dir"
cd $dir || exit 1

echo "Current remotes"
git remote -v

if git remote -v | grep -q github.com
then
    set -e
    set -x
    git remote remove origin
    git remote add origin https://gitlab.com/NicolasToussaint/linux-home-conf.git
    git fetch
    git branch --set-upstream-to=origin/master master
    set +x
    set +e

    echo
    echo "Updated remotes"
    git remote -v

else
    echo
    echo "No GitHub remote"
fi

