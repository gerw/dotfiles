#!/bin/bash

cd $(dirname $0)

# Make link to the current color-scheme
ln -sf term-recolor-light.sh term-recolor-current.sh

# Do it ;)
pkill -USR1 -u $USER bash -P $(pgrep -u $USER 'xterm|sshd' -d ,)

# Load the Xresources
xrdb -merge ~/dotfiles/solarized_xresources/Xresources.light

# Recolor i3
cat ~/.i3/config.light ~/.i3/config.in > ~/.i3/config
i3-msg reload
