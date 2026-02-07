# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set up the prompt with green username@domain, cyan path (with ~ for home) and git branch
PS1='\[\e[32m\]\u@\h\[\e[0m\] \[\e[36m\]\w\[\e[0m\]$(parse_git_branch)\n$ '

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Enable case-insensitive completion
if [ -n "$BASH_VERSION" ] && echo "$-" | grep -q i; then
  bind "set completion-ignore-case on"
  # Show completion list automatically
  bind "set show-all-if-ambiguous on"
  bind "set show-all-if-unmodified on"
  # Configure file completion
  complete -d cd
fi

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
