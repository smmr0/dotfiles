if [ -f "$HOME/.env" ]; then
	. "$HOME/.env"
fi

if [ -d "$HOME/.rbenv/bin" ]; then
	PATH="$HOME/.rbenv/bin:$PATH"
fi

if [ -d "$HOME/.rbenv/plugins/ruby-build/bin" ]; then
	PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# https://stackoverflow.com/a/677212/2384183
if command -v rbenv > /dev/null 2>&1; then
	eval "$(rbenv init -)"
fi

if [ -d "$HOME/.pyenv" ]; then
	export PYENV_ROOT="$HOME/.pyenv"

	if [ -d "$PYENV_ROOT/bin" ]; then
		PATH="$PYENV_ROOT/bin:$PATH"
	fi
fi

# https://stackoverflow.com/a/677212/2384183
if command -v pyenv > /dev/null 2>&1; then
	eval "$(pyenv init -)"

	if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
		eval "$(pyenv virtualenv-init -)"
	fi
fi

if [ -d "$HOME/.yarn/bin" ]; then
	PATH="$HOME/.yarn/bin:$PATH"
fi

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"

	if [ -s "$NVM_DIR/nvm.sh" ]; then
		. "$NVM_DIR/nvm.sh"
	fi
fi

if [ -d '/usr/local/go' ]; then
	PATH="$GOROOT/bin:$PATH"
fi

if [ -d "$HOME/go" ]; then
	export GOPATH="$HOME/go"
	PATH="$GOPATH/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# http://membled.com/work/apps/pathmerge/
export PATH="$(pathmerge "$PATH")"

if [ -n "$XDG_DATA_DIRS" ]; then
	if [ -d "$HOME/.local/share" ]; then
		XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
	fi

	export XDG_DATA_DIRS="$(pathmerge "$XDG_DATA_DIRS")"
fi

if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
