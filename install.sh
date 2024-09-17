#!/bin/bash

for f in ./.*; do
	if [ "$f" = "./." -o "$f" = "./.." -o "$f" == "./.git" ]; then
		echo skipping $f 1>&2
		continue
	fi
	dest=$HOME/$f
	if [ -f "$dest" ]; then
		echo "skipping $f: already exists?" 1>&2
		continue
	fi
	echo ln -s "$(pwd)/$f" "$dest"
done
