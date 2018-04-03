# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/local/bin" ] ; then
	PATH="$HOME/local/bin:$PATH"
fi

if [ -d "$HOME/work/Software/bin" ] ; then
	PATH="$HOME/work/Software/bin:$PATH"
fi
if [ -d "$HOME/.i3/bin" ] ; then
	PATH="$HOME/.i3/bin:$PATH"
fi
if [ -d "$HOME/dotfiles/bin" ] ; then
	PATH="$HOME/dotfiles/bin:$PATH"
fi

if [ -d "$HOME/local/lib" ] ; then
	export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
	export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH
fi

# Set path where LaTeX searches for input files
# Note: a trailing // means: recurse into subdirectories
export TEXINPUTS=$TEXINPUTS:\
$HOME/work/resources//:\
$HOME/work/cloud/optimal_control/images//:\
$HOME/TUC_work/Resources//:\
$HOME/TUC_work/Talks/Archive//:\
$HOME/TUC_work/Talks/Beamertemplate//:\
$HOME/TUC_work/Projects/Plasticity/Resources//:\
$HOME/TUC_work/Proposals/201103_SFBTR_IOfiM/IOfiM/Ressourcen/LaTeX//

# The same for bibtex
export BIBINPUTS=$BIBINPUTS:\
$HOME/work/resources/bibliography:\
$HOME/TUC_work/Resources/Bibliography:\
$HOME/TUC_work/Projects/Plasticity/Resources

# Also execute .bashrc for the invocation of bash scripts, e.g. to set up traps.
export BASH_ENV=$HOME/.bashrc

# Configure texdoc
# export TEXDOCVIEW_pdf=okular

# Define a license file
# export MOSEKLM_LICENSE_FILE=/opt/mosek/7/mosek.lic

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

