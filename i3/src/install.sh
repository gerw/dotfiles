#!/bin/bash

# Stop on errors.
set -e

gcc ipc_send_message.c root_atom_contents.c i3_vim_focus.c -o i3_vim_focus -lxdo -lX11 -lxcb -lxcb-util
cp i3_vim_focus ../bin/i3_vim_focus
