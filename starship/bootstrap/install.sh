#! /bin/bash

SRC=$(git rev-parse --show-toplevel)/etc/config.toml
DST=~/.config/starship.toml
FORCE=false

# Parse the `--force` option
case "${1:-}" in
--force)
  FORCE=true
  shift
  ;;
esac

# Check that the target exists and stop if `--force` is not specified
if [[ -f "$DST" && "$FORCE" != true ]]; then
  echo "Stop: $DST already exists and --force option not specified."
  exit 1
fi

# Copy the configuration in `etc` to the destination
if ! cp -- "$SRC" "$DST"; then
  echo "Error: could not copy $SRC to $DST." >&2
  exit 1
fi

echo "OK: successfully installed the configuration at $DST."
exit 0
