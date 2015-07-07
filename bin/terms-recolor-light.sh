#!/bin/bash

cd $(dirname $0)

# Make link to the current color-scheme
ln -sf term-recolor-light.sh term-recolor-current.sh

# Do it ;)
pkill -USR1 -u gerw bash -P $(pgrep -u gerw 'xterm|sshd' -d ,)

# Load the Xresources
xrdb -merge ~/dotfiles/solarized_xresources/Xresources.light