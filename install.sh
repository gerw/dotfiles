#!/bin/bash

cd "$(dirname "$0")"

if [ "x$HOSTNAME" = "xeuler" ]; then
	cpp <( cat Xresources solarized_xresources/Xresources.light ) "$HOME/.Xresources"
	cat i3/config.light i3/config.in > i3/config
else
	cpp <( cat Xresources solarized_xresources/Xresources.dark ) "$HOME/.Xresources"
	cat i3/config.dark i3/config.in > i3/config
fi

cd "$HOME"

#RELPATH="$(relpath "$(dirname $0)")"
RELPATH=dotfiles

for file in dircolors xsessionrc xinputrc bash_aliases bash_completion bashrc profile inputrc; do
	ln -s "$RELPATH/$file" ".$file"
done
ln -s "$RELPATH/i3" ".i3"

# if [ "x$HOSTNAME" = "xsobolev" ]; then
# 	file=xinitrc
# 	ln -s "$RELPATH/$file" ".$file"
# fi
