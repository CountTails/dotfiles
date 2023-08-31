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

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit  
fi

export CLICOLOR=1
export PATH=$HOME/.cargo/bin:/opt/homebrew/opt/postgresql@15/bin:$PATH:/usr/local/texlive/2022/bin/universal-darwin

# aliases
source ~/.aliases

# user functions
source ~/.functions

# ZSH plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/Cellar/zsh-git-prompt/0.5/zshrc.sh

# prompt customization
PROMPT=$'$(drawline)
$(timedate) | $(currworkingdir) $(git_super_status) 
$(promptarrow) '
