#!/bin/bash

# Stop on errors.
set -e

gcc -I$HOME/local/include ipc_send_message.c root_atom_contents.c i3_vim_focus.c -o i3_vim_focus -lxdo -L$HOME/local/lib -lX11 -lxcb -lxcb-util
cp i3_vim_focus ../bin/i3_vim_focus
