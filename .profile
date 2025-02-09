add_to_path() {
	new_path="$1"

	if [ -d "$new_path" ]; then
		PATH="$new_path:$PATH"
	fi
}

configure_rbenv_ish() {
	dir="$1"
	command="$2"

	add_to_path "$dir/bin"

	if [ -d "$dir/plugins" ]; then
		for plugin_dir in "$dir/plugins"; do
			add_to_path "$plugin_dir/bin"
		done
	fi

	if [ -n "$command" ]; then
		if command -v "$command" > /dev/null 2>&1; then
			eval "$("$command" init -)"
		fi
	fi
}

if [ -f "$HOME/.env" ]; then
	. "$HOME/.env"
fi

path_without_brew="$PATH"
if [ -d "$HOME/.linuxbrew" ]; then
	eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
fi
if [ -d '/home/linuxbrew/.linuxbrew' ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
if [ -d '/opt/homebrew' ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
PATH="$path_without_brew:$PATH" # Move Homebrew to end of `PATH`

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"

	if [ -s "$NVM_DIR/nvm.sh" ]; then
		. "$NVM_DIR/nvm.sh"
	fi
fi

configure_rbenv_ish "$HOME/.erlenv" erlenv
configure_rbenv_ish "$HOME/.exenv" exenv
configure_rbenv_ish "$HOME/.jenv" jenv
configure_rbenv_ish "$HOME/.pyenv"
if command -v pyenv > /dev/null 2>&1; then
	eval "$(pyenv init --path)"

	if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
		eval "$(pyenv virtualenv-init -)"
	fi
fi
configure_rbenv_ish "$HOME/.nodenv" nodenv
configure_rbenv_ish "$HOME/.rbenv" rbenv

add_to_path "${ASDF_DATA_DIR:-$HOME/.asdf}/bin"
add_to_path "${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

add_to_path "$HOME/.yarn/bin"

add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"

if command -v pathmerge > /dev/null 2>&1; then
	# http://membled.com/work/apps/pathmerge/
	export PATH="$(pathmerge "$PATH")"
fi

if [ -n "$XDG_DATA_DIRS" ]; then
	if [ -d "$HOME/.local/share" ]; then
		XDG_DATA_DIRS="$HOME/.local/share:$XDG_DATA_DIRS"
	fi

	if command -v pathmerge > /dev/null 2>&1; then
		export XDG_DATA_DIRS="$(pathmerge "$XDG_DATA_DIRS")"
	fi
fi

if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
