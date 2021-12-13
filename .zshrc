# Prompt custumization
PROMPT='%F{25}%W (%T)%f | %F{136}%U%d%u%f $(git_super_status)
'$'\U27A4'' ' #unicode sequence for the arrow prompt. the $ forces the sequence to be expanded

# ZSH plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Startup fortune
fortune | cowsay -f tux
