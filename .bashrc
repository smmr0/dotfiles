# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

set -o vi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x '/usr/bin/lesspipe' ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r '/etc/debian_chroot' ]; then
    debian_chroot="$(cat /etc/debian_chroot)"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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

if [ "$color_prompt" = yes ]; then
    if [ -n "$POWERLINE" ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[1;97;45m\]\u@\h\[\033[21;24;35;44m\]\[\033[1;97m\]\w\[\033[34m\]$(__git_ps1 "\[\033[21;24;34;42m\]\[\033[1;97m\]%s\[\033[32m\]")\[\033[49m\]\[\033[0m\]'
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[1;35m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]$(__git_ps1 "@\[\033[1;32m\]%s\[\033[0m\]")\[\033[35m\]\$\[\033[0m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 "@%s")\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
PROMPT_COMMAND='echo -en "\033]0;$(whoami)@$(hostname -s):$(dirs -0)$(__git_ps1 "@%s")\a"'

# enable color support of ls and also add handy aliases
if [ -x '/usr/bin/dircolors' ]; then
    test -r '~/.dircolors' && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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
# For macOS
export CLICOLOR=true

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.bash_aliases.local" ]; then
    . "$HOME/.bash_aliases.local"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
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
			[[ -r "$completion" ]] && source "$completion"
		done
	fi


	if [ -n "$NVM_DIR" ]; then
		if [ -f "$NVM_DIR/bash_completion" ]; then
			. "$NVM_DIR/bash_completion"
		fi
	fi

	if command -v doctl > /dev/null 2>&1; then
		source <(doctl completion bash)
	fi
fi

if command -v pyenv > /dev/null 2>&1; then
	eval "$(pyenv init -)"
fi
