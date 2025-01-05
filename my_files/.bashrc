# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set up the prompt with cyan path and git branch
# \[\e[36m\] starts cyan color
# \[\e[0m\] resets color
# \w shows current working directory with ~ for home
PS1='\[\e[36m\]\w\[\e[0m\]$(parse_git_branch) $ '

alias hi="echo 'hi there, this is a testing commend to see if this works'"

alias gits="git status"
