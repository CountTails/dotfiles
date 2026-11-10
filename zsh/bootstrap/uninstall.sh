#! /bin/bash

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

# Require confirmation unless explicitly skipped
if [[ "$SKIP_CONFIRMATION" != true ]]; then
  printf 'Warning: "%s" and "%s" will be removed permanently. Continue? [y/N] ' "$INIT_FILE" "$ENV_FILE"
  read -r confirmation

  case "$confirmation" in
  y | Y | yes | YES | Yes)
    ;;
  *)
    echo "Operation cancelled."
    exit 1
    ;;
  esac
fi

# Remove the ~/.zshrc
if ! rm -f "$INIT_FILE"; then
  echo "Error: failed to prune link: $INIT_FILE" >&2
  exit 1
fi

# Remove the ~/.zshenv
if ! rm -f "$ENV_FILE"; then
  echo "Error: failed to prune link: $ENV_FILE" >&2
  exit 1
fi

echo "OK: configuration successfully removed"
exit 0
