# .bashrc

# User specific aliases and functions

stty -tostop

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

[ -f ${HOME}/.sh/fb.sh ] && . ${HOME}/.sh/fb.sh

if [ $(uname -s) = "Linux" ]; then
       HOSTNAME=$(hostname -s) # doesn't work in standard unices
else
       HOSTNAME=$(hostname)
fi

set -o vi

