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

eval "$(starship init zsh)"
