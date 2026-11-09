#
# file: env.zsh
# purpose: some configuration values for launching new ZSH sessions
#


# prefixes for a Homebrew (https://brew.sh/) installation
homebrew_prefixes=(
	"/opt/homebrew" # macOS apple silicon
	"/usr/local" # macOS intel
	"/home/linuxbrew/.linuxbrew" # linux install
)

# directories to look for plugins in
plugin_dirs=(
	"/usr/share/zsh/plugins"
	"$HOME/.local/share/zsh/plugins"
)

# names of plugin scripts to load (relative to a plugin director)
plugins=(
	"zsh-autosuggestions/zsh-autosuggestions.zsh"
	"zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
)
