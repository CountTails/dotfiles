#! /bin/bash

SKIP_CONFIRMATION=false
DST=~/.config/starship.toml

# Parse the `--skip-confirmation` option
case "${1:-}" in
--skip-confirmation)
  SKIP_CONFIRMATION=true
  shift
  ;;
esac

# Check that the target exists
if [[ ! -f "$DST" ]]; then
  echo "Error: configuration does not exist: $DST_DIR" >&2
  exit 1
fi

# Require confirmation unless explicitly skipped
if [[ "$SKIP_CONFIRMATION" != true ]]; then
  printf 'Warning: "%s" will be removed permanently. Continue? [y/N] ' "$DST"
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

# Remove the configuration
if ! rm -f -- "$DST"; then
  echo "Error: failed to remove config: $DST" >&2
  exit 1
fi

echo "OK: configuration successfully removed"
exit 0
