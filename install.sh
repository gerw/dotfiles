#!/bin/bash

cd "$(dirname "$0")"

if [ "x$HOST" = "xcantor" ]; then
	cat Xresources solarized_xresources/Xresources.light > "$HOME/.Xresources"
else
	cat Xresources solarized_xresources/Xresources.dark > "$HOME/.Xresources"
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
