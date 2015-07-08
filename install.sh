#!/bin/bash

cd $(dirname $0)

if [ "x$HOST" = "xcantor" ]; then
	cat Xresources solarized_xresources/Xresources.light > ../.Xresources
else
	cat Xresources solarized_xresources/Xresources.dark > ../.Xresources
fi
