# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

shopt -s globstar 2> /dev/null || :

set -o vi

abbr_path() {
	path="$1"
	ellipsis="$2"
	min_affix_len="$3"

	if [ "$PWD" = '/' ]; then
		printf '/'
		return
	fi

	if ! command -v tac > /dev/null 2> /dev/null && echo | tail -r > /dev/null 2>&1; then
		tac='tail -r'
	else
		tac='tac'
	fi

	cd "$path"

	while :; do
		if [ "$PWD" = '/' ]; then
			echo
			break
		fi
		if [ "$PWD" = "$HOME" ]; then
			echo '~'
			break
		fi

		basename="$(basename "$PWD")"

		if [ "${basename:0:1}" = '.' ]; then
			prefix_len="$((min_affix_len+1))"
		else
			prefix_len="$min_affix_len"
		fi
		suffix_len="$min_affix_len"

		while
			prefix="${basename:0:$prefix_len}"
			suffix="${basename: -$suffix_len}"

			[ "$(find .. ! -name .. -prune -name "${prefix}*${suffix}" | head -2 | wc -l)" -gt 1 ]
		do
			prefix_len="$((prefix_len+1))"
			suffix_len="$((suffix_len+1))"
		done

		if [ "$((${#prefix}+${#suffix}+1))" -lt "${#basename}" ]; then
			echo "$prefix$ellipsis$suffix"
		else
			echo "$basename"
		fi

		cd ..
	done | $tac | tr $'\n' '/' | sed 's/\/$//'
}

color() {
	echo -n '\[\033['
	local print_semicolon=''
	for color in "$@"; do
		if [ -n "$print_semicolon" ]; then
			echo -n ';'
		else
			local print_semicolon='1'
		fi
		# https://misc.flogisoft.com/bash/tip_colors_and_formatting
		case "$color" in
			'reset_all') echo -n '0' ;;

			'bold') echo -n '1' ;;
			'dim') echo -n '2' ;;

			'reset_bold') echo -n '21' ;;
			'reset_dim') echo -n '22' ;;

			'bg_default') echo -n '49' ;;
			'bg_red') echo -n '41' ;;
			'bg_green') echo -n '42' ;;
			'bg_blue') echo -n '44' ;;
			'bg_magenta') echo -n '45' ;;

			'fg_default') echo -n '39' ;;
			'fg_red') echo -n '31' ;;
			'fg_green') echo -n '32' ;;
			'fg_blue') echo -n '34' ;;
			'fg_magenta') echo -n '35' ;;
			'fg_white') echo -n '97' ;;
		esac
	done
	echo -n 'm\]'
}

# Make less more friendly for non-text input files, see lesspipe(1)
if [ -x '/usr/bin/lesspipe' ]; then
	eval "$(SHELL=/bin/sh lesspipe)"
fi

if [ -z "${debian_chroot:-}" ] && [ -r '/etc/debian_chroot' ]; then
	debian_chroot="$(cat /etc/debian_chroot)"
fi

case "$TERM" in
	xterm-color|*-256color)
		export CLICOLOR='1'
		export COLORTERM='1'
esac

# __git_ps1 may already be sourced from e.g. /etc/bash_completion.d/git-prompt
# on Ubuntu (which in turn sources /usr/lib/git-core/git-sh-prompt); if not, it
# can be sourced via Git's source code (e.g. via download or sparse checkout) at
# <https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh> and
# placed into /etc/bash_completion.d/ or ~/.local/etc/bash_completion.d/, for
# example.
if ! command -v __git_ps1 > /dev/null 2>&1; then
	__git_ps1() {
		:
	}
fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_STATESEPARATOR=
GIT_PS1_COMPRESSSPARSESTATE=true
GIT_PS1_SHOWCONFLICTSTATE=yes

if [ -n "$CLICOLOR" ] && [ -n "$POWERLINE" ]; then
	PS1=$(tr -d $'\n' <<- EOF
		\$([ "\$(id -u)" = '0' ] && echo '$(color bg_red)' || echo '$(color bg_magenta)')
		$(color fg_white bold)
		\${debian_chroot:+(\$debian_chroot)}\\u@\\h

		$(color bg_blue)
		\$([ "\$(id -u)" = '0' ] && echo '$(color fg_red)' || echo '$(color fg_magenta)')
		

		$(color fg_white)
		\$([ -n "\$ABBR_PATH" ] && abbr_path . '$(color dim)*$(color reset_dim bold)' 1 || echo '\w')

		$(color fg_blue)
		\$(__git_ps1 '$(color bg_green)$(color fg_white)%s$(color fg_green)')

		$(color bg_default)
		

		$(color bg_default fg_default reset_bold reset_underline)
	EOF
	)
elif [ -n "$CLICOLOR" ]; then
	PS1=$(tr -d $'\n' <<- EOF
		\$([ "\$(id -u)" = '0' ] && echo '$(color fg_red)' || echo '$(color fg_magenta)')
		$(color bold)
		\${debian_chroot:+(\$debian_chroot)}\\u@\\h

		$(color fg_default reset_bold reset_underline)
		:

		$(color fg_blue bold)
		\$([ -n "\$ABBR_PATH" ] && abbr_path . '$(color fg_white dim)*$(color reset_dim fg_blue bold)' 1 || echo '\w')

		$(color fg_default reset_bold reset_underline)
		\$(__git_ps1 '@$(color fg_green bold)%s$(color fg_default reset_bold reset_underline)')

		\$([ "\$(id -u)" = '0' ] && echo '$(color fg_red)#' || echo '$(color fg_magenta)\$')

		$(color fg_default)
		$(echo ' ')
	EOF
	)
else
	PS1=$(tr -d $'\n' <<- EOF
		\${debian_chroot:+(\$debian_chroot)}\u@\h
		:
		\$([ -n "\$ABBR_PATH" ] && abbr_path . '*' 1 || echo '\w')
		\$(__git_ps1 '@%s')
		\$
		$(echo ' ')
	EOF
	)
fi

case "$TERM" in xterm*|rxvt*) PS1="\[\e]0;\${debian_chroot:+(\$debian_chroot)}\u@\h: \w\a\]$PS1"; esac
PROMPT_COMMAND='echo -en "\033]0;${debian_chroot:+($debian_chroot)}$(whoami)@$(hostname -s):$(dirs -0)$(__git_ps1 "@%s")\a"'

if command -v dircolors > /dev/null 2>&1; then
	if [ -r "$HOME/.dircolors" ]; then
		eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
	fi
	alias ls='ls --color=auto'
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
fi

echo -n | grep --color '' > /dev/null 2>&1
if [ $? -le 1 ]; then
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

if diff --color=auto /dev/null /dev/null > /dev/null 2>&1; then
	alias diff='diff --color=auto'
fi

unset color

if [ -f "$HOME/.bash_aliases" ]; then
	. "$HOME/.bash_aliases"
fi

if ! shopt -oq posix; then
	if [ -f "$PREFIX/usr/share/bash-completion/bash_completion" ]; then
		. "$PREFIX/usr/share/bash-completion/bash_completion"
	fi

	if [ -f "$PREFIX/etc/bash_completion" ]; then
		. "$PREFIX/etc/bash_completion"
	fi

	if [ -f "$PREFIX/usr/local/etc/bash_completion" ]; then
		. "$PREFIX/usr/local/etc/bash_completion"
	fi

	if [ -f "$HOME/.local/etc/bash_completion" ]; then
		. "$HOME/.local/etc/bash_completion"
	fi

	# https://docs.brew.sh/Shell-Completion#configuring-completions-in-bash
	if command -v brew &>/dev/null 2>&1; then
		if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
			source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
		fi

		for completion in "$(brew --prefix)/etc/bash_completion.d/"*; do
			if [ -r "$completion" ]; then
				. "$completion"
			fi
		done
	fi


	if [ -n "$NVM_DIR" ] && [ -f "$NVM_DIR/bash_completion" ]; then
		. "$NVM_DIR/bash_completion"
	fi

	if command -v doctl > /dev/null 2>&1; then
		source <(doctl completion bash)
	fi
fi

if command -v pyenv > /dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

if [ -f "$HOME/.bashrc.local" ]; then
	. "$HOME/.bashrc.local"
fi
