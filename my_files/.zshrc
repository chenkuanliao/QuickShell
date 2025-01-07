# Load version control information
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Configure vcs_info for git
zstyle ':vcs_info:git:*' formats '%b'

# Precmd function to get git information
my_precmd() {
  vcs_info
  psvar[1]=$vcs_info_msg_0_
  if [[ -n ${psvar[1]} ]]; then
    psvar[1]=" (${psvar[1]})"
  fi
}

# Add the precmd hook
add-zsh-hook precmd my_precmd

# Set the prompt with cyan path and ~ for home directory (%~ instead of %d)
PROMPT='%F{cyan}%~%f%1v
$ '

# alias
alias hi="echo 'hi there, this is a testing commend to see if this works'"

# commands for git
alias gs="git status"
alias gl="git log"
alias ga="git add"
alias gap="git add -p"
alias gpull="git push"
alias gc="git commit -m"
alias gpush="git push"

# helper tools
alias htmux='function _helper() { grep -A 1 "$1" "$MY_FILES/helperTmux.txt"; }; _helper'
