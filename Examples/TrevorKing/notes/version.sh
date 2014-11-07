#!/bin/bash

if [ "$1" = '-s' ]; then
	filename=$(date +'%Y-%m-%dT%H-%M-%S-software-versions')
	exec >"versions/$filename"
fi

echo "Live Git packages"
echo
for package in /usr/src/linux.git/.git /usr/portage/distfiles/egit-src/*; do
	name=$(basename "$package")
	if [ "$name" = '.git' ]; then
		name=$(basename $(dirname "$package"))
	fi
	echo -en "$name\t"
	GIT_DIR="$package" git --no-pager log -n1 --oneline
done

echo
echo "Live Subversion packages"
echo
for package in /usr/portage/distfiles/svn-src/*; do
	name=$(basename "$package")
	echo -en "$name\t"
	svn info "$package"/trunk
done

echo
echo "Dead packages"
echo
for package in /var/db/pkg/*/*; do
	name_version=$(basename "$package")
	category=$(basename $(dirname "$package"))
	echo "=$category/${name_version}"
done
