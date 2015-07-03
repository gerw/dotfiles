#!/bin/bash

cd ~/dotfiles/bin

# Now, look at the link term-recolor-current.sh
readlink term-recolor-current.sh  | grep -o "dark\|light"
