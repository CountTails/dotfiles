#! /bin/bash

SRC=$(git rev-parse --show-toplevel)/zsh/config
FORCE=false

INIT_FILE=$HOME/.zshrc
ENV_FILE=$HOME/.zshenv

# Parse the `--force` option
case "${1:-}" in
--force)
  FORCE=true
  shift
  ;;
esac

# Check for an existing ~/.zshrc and bail if force is not specified
if [[ -f $INIT_FILE && "$FORCE" != true ]]; then
  echo "Error": $INIT_FILE exists and --force option not specified
  exit 1
fi

# Check for an existing ~/.zshenv and bail if force is not specified
if [[ -f $ENV_FILE && "$FORCE" != true ]]; then
  echo "Error: $ENV_FILE exists and --force option not specified"
  exit 1
fi

# Remove existing ~/.zshrc
if ! rm -vf -- "$INIT_FILE"; then
  echo "Error: could not remove existing ~/.zshrc"
  exit 1
fi

# Remove existig ~/.zshenv
if ! rm -vf -- "$ENV_FILE"; then
  echo "Error: could not remove existing ~/.zshenv"
  exit 1
fi

if ! cp -v -- "$SRC/init.zsh" "$INIT_FILE"; then
  echo "Error: could not copy to ~/.zshrc"
  exit 1
fi

if ! cp -v -- "$SRC/env.zsh" "$ENV_FILE"; then
  echo "Error: could not copy to ~/.zshenv"
  exit 1
fi

echo OK: ZSH configuration successfully installed 
echo TIP: Remember to reload ~/.zshrc for new configuration to take affect!
exit 0
