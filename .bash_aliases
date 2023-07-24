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
