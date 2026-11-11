#! /bin/bash

REAL="$HOME/.config/git"
LINK="$HOME/.gitconfig"
FORCE=false

# Parse the `--force` option
case "${1:-}" in
--force)
  FORCE=true
  shift
  ;;
esac

# Check that the targets exists and stop if `--force` is not specified
if [[ ! -L "$LINK" ]]; then
  echo "Error: no such symlink ($LINK)"
  exit 1
fi

if [[ ! -d "$REAL" ]]; then
  echo "Error: no such directory ($REAL)"
  exit 1
fi

# Require confirmation unless explicitly skipped
if [[ "$FORCE" != true ]]; then
  printf 'Warning: "%s" and "%s" will be removed permanently. Continue? [y/N] ' "$REAL" "$LINK"
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

# Remove symlink
if ! rm -f -- "$LINK"; then
  echo "Error: failed to remove link ($LINK)"
  exit 1
fi

# Remove real config file
if ! rm -rf -- "$REAL"; then
  echo "Error: failed to remove config ($REAL)"
  exit 1
fi

echo "OK: configuration successfully removed"
exit 0
