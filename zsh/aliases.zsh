# aliases
# aliases for (modern) ls
alias ls="eza"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -al"

# aliases for (modern) cat
alias cat="bat"
alias catp="cat -p"

# aliases for rm/mv/cp
alias rm="rm -i"
alias mv="mv -v"
alias cp="cp -v"

# aliases for git
alias ga="git add"
alias gp="git push"
alias gl="git log"
alias gs="git status"
alias gd="git diff"
alias gm="git commit -m"
alias gma="git commit -am"
alias gb="git branch"
alias gc="git checkout"
alias gra="git remote add"
alias grr="git remote rm"
alias gpu="git pull"
alias gcl="git clone"

# aliases for homebrew
alias brewp="brew pin"
alias brews="brew list -1"
alias brewsp="brew list --pinned"
alias bubo="brew update && brew outdated --formula && brew outdated --cask"
alias bubc='brew upgrade && brew cleanup'
alias bubu="bubo && bubc"
alias buf="brew upgrade --formula"
alias bcubo="brew update && brew outdated --cask"
alias bcubc="brew upgrade --cask && brew cleanup"

# aliases for python
alias python="python3"
