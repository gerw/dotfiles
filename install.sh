#!/bin/bash

cd "$(dirname "$0")"

if [ "x$HOST" = "xcantor" ]; then
	cpp <( cat Xresources solarized_xresources/Xresources.light ) "$HOME/.Xresources"
	cat i3/config.light i3/config.in > i3/config
else
	cpp <( cat Xresources solarized_xresources/Xresources.dark ) "$HOME/.Xresources"
	cat i3/config.dark i3/config.in > i3/config
fi

cd "$HOME"

RELPATH="$(relpath "$(dirname $0)")"

for file in dircolors xsessionrc; do
	ln -s "$RELPATH/$file" ".$file"
done

if [ "x$HOST" = "xcantor" ]; then
	file=xinitrc
	ln -s "$RELPATH/$file" ".$file"
fi
