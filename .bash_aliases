# -1: "list one file per line"
#
# I'd prefer to use `-x`, but that outputs multiple columns even when piped. So
# instead I'll use `-1`, so that between this and the `l` alias below, only one
# columned output format will be used, reducing my confusion.
if ls -1 /dev/null > /dev/null 2>&1; then
	alias ls="${BASH_ALIASES[ls]:-ls} -1"
fi
alias l='ls -AFHx'
alias la='ls -aFl'
# -h, --human-readable: "with -l and -s, print sizes like 1K 234M 2G etc."
if la -h /dev/null > /dev/null 2>&1; then
	alias la="${BASH_ALIASES[la]} -h"
fi

alias nom='kill'
alias nomall='killall'

alias bim='vim'
alias be='bundle exec'
alias yr='yarn run --silent'

alias todo='todo.sh'
complete -F _todo todo
alias t='todo'
complete -F _todo t

if [ -f "$HOME/.bash_aliases.local" ]; then
	. "$HOME/.bash_aliases.local"
fi
