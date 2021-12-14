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

# prompt customization
PROMPT='$(drawline)
$(timedate) | $(currworkingdir) $(git_super_status)
$(promptarrow) '



# ZSH plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Startup fortune
fortune | cowsay -f tux
