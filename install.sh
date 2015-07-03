#!/bin/bash

cd $(dirname $0)

# Todo: use light on MRZ computers
cat Xresources solarized_xresources/Xresources.dark > ../.Xresources
