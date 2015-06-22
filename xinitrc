#!/bin/bash

# Only used at work with OpenSuse, since it does not source .xsessionrc by default.

# This file is more or less transparent.
# It sources
#   ~/.xsessionrc
# and then fallback to the standard
#   /etc/X11/xinit/xinitrc

# Some logging "features":
# logfile=xinitrc.log
#
# date >> $logfile
#
# pstree >> $logfile
#
# ps ax >> $logfile
#
# env >> $logfile
#
# echo "wm: $WINDOWMANAGER" >> $logfile

if [ "x$WINDOWMANAGER" = "x/usr/bin/i3" ]; then
	# Yeah, we are on i3.

	if [ -f $HOME/.xsessionrc ]; then
		source $HOME/.xsessionrc
	fi

fi

# env >> $logfile

# Now start the windowmanager
source /etc/X11/xinit/xinitrc
