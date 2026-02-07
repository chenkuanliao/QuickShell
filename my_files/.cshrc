# Function to get git branch
alias parse_git_branch 'git branch |& grep "\*" | sed -e "s/\* \(.*\)/ (\1)/"'
# Set the prompt with green username@domain, cyan path and git branch
set prompt = "%{\e[32m%}%n@%m%{\e[0m%} %{\e[36m%}%~%{\e[0m%}`parse_git_branch`\n$ "

# Enable programmable completion
complete cd 'p/1/d/'
complete git 'p/1/(status log add commit push pull)/'
set filec
set autolist
set autoexpand

# my alias
alias hi 'echo "hi there, this is a testing commend to see if this works"'

# commands for git
alias gs 'git status'
alias gl 'git log'
alias ga 'git add'
alias gap 'git add -p'
alias gpull 'git pull'
alias gc 'git commit -m'
alias gpush 'git push'
alias ll 'ls -alF'

# helper tools
# Helper function for tmux commands
alias htmux 'grep -A 1 \!:1 $MY_FILES/helperTmux.txt'

# QuickShell restore alias
alias qsrestore '$HOME/.quickshell_backup/quickshell_restore.sh'
