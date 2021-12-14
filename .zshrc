## zsh personal functions
function drawline(){
    for i in {1..$COLUMNS}
    do
        echo -n '_' 
    done;
    echo
} 

#precmd
function precmd() {
    drawline
}

# Prompt custumization
PROMPT='%F{25}%W (%T)%f | %F{136}%U%d%u%f $(git_super_status)
'$'\U27A4'' ' #unicode sequence for the arrow prompt. the $ forces the sequence to be expanded

# zsh personal functions
function drawline(){
    for i in {1..$COLUMNS}
    do
        echo -n '_' 
    done;
    echo
}

# ZSH plugins
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Startup fortune
fortune | cowsay -f tux
