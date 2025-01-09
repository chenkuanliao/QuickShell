# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set up the prompt with cyan path and git branch
PS1='\[\e[36m\]\w\[\e[0m\]$(parse_git_branch) 
$ '

# my alias 
alias hi="echo 'hi there, this is a testing commend to see if this works'"

# commands for git
alias gs="git status"
alias gl="git log"
alias ga="git add"
alias gap="git add -p"
alias gpull="git push"
alias gc="git commit -m"
alias gpush="git push"
alias ll='ls -alF'

# helper tools
# Helper function for tmux commands
htmux() {
    grep -A 1 "$1" "$MY_FILES/helperTmux.txt"
}
