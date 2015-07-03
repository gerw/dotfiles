#!/bin/sh
# Send in a .Xresources to recolor your terminal!

# Due to http://superuser.com/a/921802

# See also
# http://rtfm.etla.org/xterm/ctlseq.html
# for the control sequences
cpp | tr -d ' \t' | sed -n '
s/.*cursorColor:/\x1b]12;/p
s/.*background:/\x1b]11;/p
s/.*foreground:/\x1b]10;/p
s/.*color\([0-9][^:]*\):/\x1b]4;\1;/p
' | tr \\n \\a
