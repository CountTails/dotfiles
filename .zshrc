# zsh user functions

# print out a dotted line accross the terminal
function drawline(){
    for i in {1..$COLUMNS}
    do
        echo -n '%(?.%F{green}%U %u%f.%F{red}%U %u%f)' 
    done;
    echo
} 

# print out the current time and date with styling
function timedate(){
    local TIMEDATE='%F{25}%W [%T]%f'
    echo $TIMEDATE
}

# print out the current workind directory with styling
function currworkingdir(){
    local PWD='%F{136}%U%d%u%f'
    echo $PWD
}

# print a solid right arrow to indicate start of standard input
function promptarrow(){
    local PROMPTARROW='\U27A4'
    echo $PROMPTARROW
}

# set environment variables
if [ $(uname) = Linux ] ; then
    if [ $(uname -m) = x86_64 ] ; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo "Homebrew binaries not included in $PATH"
    fi
elif [ $(uname) = Darwin ] ; then
    if [ $(uname -m) = x86_64 ] ; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [ $(uname -m) = arm64 ] ; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew binaries not included in $PATH"
    fi
else
    echo "Homebrew binaries not included in $PATH"
fi

export CLICOLOR=1
export PATH=$PATH:/usr/local/texlive/2022/bin/universal-darwin
export CATALINA_HOME=/opt/homebrew/Cellar/tomcat/10.0.20/libexec


# ZSH plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/Cellar/zsh-git-prompt/0.5/zshrc.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# prompt customization
PROMPT="$(drawline)
$(timedate) | $(currworkingdir) $(git_super_status)
$(promptarrow) "

# Startup fortune
fortune | cowsay -f tux

# aliases
# aliases for (modern) ls
alias ls="exa"

# aliases for (modern) cat
alias cat="bat"

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
alias gta="git tag -a -m"
alias gf="git reflog"

# aliases for homebrew
alias brewp="brew pin"
alias brews="brew list -1"
alias brewsp="brew list --pinned"
alias bubo="brew update && brew outdated"
alias bubc='brew upgrade && brew cleanup'
alias bubu="bubo && bubc"
alias buf="brew upgrade --formula"
alias bcubo="brew update && brew outdated --cask"
alias bcubc="brew upgrade --cask && brew cleanup"
