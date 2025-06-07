# -1: "list one file per line"
#
# I'd prefer to use `-x`, but that outputs multiple columns even when piped. So
# instead I'll use `-1`, so that between this and the `l` alias below, only one
# columned output format will be used, reducing my confusion.
if ls -1 /dev/null > /dev/null 2>&1; then
	alias ls="${BASH_ALIASES[ls]:-ls} -1"
fi
alias l='ls -AFHx'
# -h, --human-readable: "with -l and -s, print sizes like 1K 234M 2G etc."
if ls -h /dev/null > /dev/null 2>&1; then
	alias la='ls -aFlh'
else
	alias la='ls -aFl'
fi
alias l1='l -1'
alias lr='l -R'

alias stop='kill'
alias stopall='killall'

alias bim='vim'
alias be='bundle exec'
alias yr='yarn run --silent'

if command -v todo.sh > /dev/null 2>&1; then
	alias todo='todo.sh'
	alias t='todo'

	# mkdir -p ~/.local/share/bash-completion/completions
	# cd ~/.local/share/bash-completion/completions
	# ln -s /path/to/todo.txt-cli/todo_completion todo.sh
	# https://github.com/scop/bash-completion/issues/521#issuecomment-2338162329
	if complete -p todo.sh 2> /dev/null || _comp_load todo.sh 2> /dev/null; then
		complete -F _todo todo
		complete -F _todo t
	fi
fi

if [ -f "$HOME/.bash_aliases.local" ]; then
	. "$HOME/.bash_aliases.local"
fi
