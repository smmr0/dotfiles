# Partially borrowed from Ubuntu's defaults

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d $HOME/.rbenv/bin ]; then
	export PATH="$HOME/.rbenv/bin:$PATH"
fi
if [ -d $HOME/.rbenv/plugins/ruby-build/bin ]; then
	export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi
# https://stackoverflow.com/a/677212/2384183
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

if [ -d /usr/local/go ]; then
	export GOROOT=/usr/local/go
	PATH="$GOROOT/bin:$PATH"
fi
if [ -d $HOME/go ]; then
	export GOPATH=$HOME/go
	PATH="$GOPATH/bin:$PATH"
fi

if [ -d $HOME/.local/bin ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

# http://membled.com/work/apps/pathmerge/
PATH=$(pathmerge $PATH)

[ -f "$HOME/.env" ] && . "$HOME/.env"
