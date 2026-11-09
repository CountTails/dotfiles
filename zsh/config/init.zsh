#
# file: init.zsh
# purpose: initializes a Z shell session with personalized settings
#


# BEGIN: environment: sets up shell environement variables

for prefix in "${homebrew_prefixes[@]}"; do
  if [[ -x "$prefix/bin/brew" ]]; then
    eval "$($prefix/bin/brew shellenv)"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
    break
  fi
done

# configure rust binaries install via cargo
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# configure go binaries install via go
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# Honestly, I forgot why this is here
export CLICOLOR=1

# Directories to lookup binaries
export PATH=$PATH

# Ignore commands that start with spaces and duplicates.
export HISTCONTROL=ignoreboth

# Don't add certain commands to the history file.
export HISTORY_IGNORE="(\&|[bf]g|c|clear|history|exit|q|pwd|* --help)"

# Make new shells get the history lines from all previous shells instead of the default "last window closed" history.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# END: environment

# BEGIN: aliases and functions: manages the aliases and user-functions of the shell configuration

# aliases for (modern ls)
if type eza &>/dev/null
then
  alias ls='eza'
fi

alias ll='ls -l'
alias la='ls -a'
alias lla='las -al'

# aliases for (modern cat)
if type bat &>/dev/null
then 
  alias cat='bat'
  alias catp='cat -p'
  alias catd='cat -d'
  alias catpd='cat -pd'
else
  alias cat='cat -n'
  alias catp='cat'
fi

# aliases for rm/mv/cp
alias rm='rm -i'
alias mv='mv -v'
alias cp='cp -v'

# aliases for git
if type git &>/dev/null
then
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
fi

# aliases for homebrew
if type brew &>/dev/null
then
  alias brewp="brew pin"
  alias brews="brew list -1"
  alias brewsp="brew list --pinned"
  alias bubo="brew update && brew outdated --formula && brew outdated --cask"
  alias bubc='brew upgrade && brew cleanup'
  alias bubu="bubo && bubc"
  alias buf="brew upgrade --formula"
  alias bcubo="brew update && brew outdated --cask"
  alias bcubc="brew upgrade --cask && brew cleanup"
fi

# alias for pacman
if type pacman &>/dev/null
then
  # install, update, remove
  alias pup='sudo pacman -Syu'
  alias pins='sudo pacman -S'
  alias prm='sudo pacman -Rns'

  # search and package info
  alias psearch='pacman -Ss'
  alias pinfo='pacman -Si'       # repository package info
  alias pinfoi='pacman -Qi'      # installed package info

  # inspect installed packages and files
  alias pinstalled='pacman -Qe'  # explicitly installed packages
  alias pfiles='pacman -Ql'      # files belonging to a package
  alias powner='pacman -Qo'      # package that owns a file
  alias porphans='pacman -Qdt'   # list orphan packages
fi

# find all markdown files in a given directory and create markdown links from them
function mdlinks() {
    find "$1" -type f -name "*.md" | while read -r file_path; do
        file_name=$(basename "$file_path" .md)
        formatted_title=$(echo "$file_name" | awk '{ for(i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); } 1' | sed -E "s/(^|-)\w/\U&/g; s/-/ /g")
        echo "[$formatted_title]($file_path)"
    done
}

# copy the contents of a given directory to a destination directory (but only if the destination if empty!)
function cpdir() {
  if [ ! -z "$(ls -A $1)" ]; then
    echo "Error: directory is not empty"
  fi

  if ! cp -- "$1/" "$2/"; then
    echo "Error: could not copy $SRC to $DST." >&2
  else
    echo "OK: successfully installed the configuration at $DST."
  fi
}

# create a directory (including parents) and enter it
function mkcd() {
  if (( $# != 1 )); then
    print -u2 -- 'Usage: mkcd DIRECTORY'
    return 2
  fi

  command mkdir -p -- "$1" && builtin cd -- "$1"
}


# go to the root of the current git repo
function gitroot() {
  local root
  root=$(command git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 -- 'Not inside a Git repository'
    return 1
  }
  builtin cd -- "$root"
}

# find aliases that may be set for a given program
function aliasfor() {
  if [[ $# == 0 ]]; then
    alias -L
  else
    alias -L | grep -i -- "$*"
  fi
}

# END: aliases and functions

# BEGIN: plugins and prompt customization: discover and load plugins for the shell session

# if brew is configured, include the its share directory in plugin_dirs
if type brew &>/dev/null
then
  plugin_dirs+=("$(brew --prefix)/share")
fi

# attempt to source $dir/$plugin if it exists (first one to succeed is used)
for plugin in "${plugins[@]}"; do
  for dir in "${plugin_dirs[@]}"; do
    if [[ -f "$dir/$plugin" ]]; then
      source "$dir/$plugin"
      break
    fi
  done
done

# Configure the ZSH session prompt using starship
eval "$(starship init zsh)"

# END: plugins and prompt customization
