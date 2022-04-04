alias bim='vim'
alias be='bundle exec'
alias r='bundle exec rails'
alias rc='bundle exec rails console'
alias ne='nvm exec --silent'
alias yr='yarn run --silent'
alias neyr='nvm exec --silent yarn run --silent'

if command -v awsv2 > /dev/null 2>&1; then
	alias aws='awsv2'

	aws_path="$(aws --version | sed -n 's/^AWS CLI v2 command:\s*//p')"
	aws_completer_path="$(dirname "$aws_path")/aws_completer"
	aws_completer_realpath="$(realpath "$aws_completer_path")"
	chmod +x "$aws_completer_realpath"
	alias aws_completer="$aws_completer_path"
fi
