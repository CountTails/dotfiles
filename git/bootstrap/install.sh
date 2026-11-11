#! /bin/bash

SRC="$(git rev-parse --show-toplevel)/git/config"
DST="$HOME/.config/git"
INIT_FILE="$DST/common.toml"
INIT_LINK="$HOME/.gitconfig"

# Parse the `--force` option
case "${1:-}" in
--force)
    FORCE=true
    shift
    ;;
esac

# Check for an existing ~/.gitignore and bail if force is not specified
if [[ -L $INIT_LINK && "$FORCE" != true ]]; then
    echo "Error": $INIT_LINK exists and --force option not specified
    exit 1
fi

# Check that the target exists and stop if `--force` is not specified
if [[ -d "$DST" && "$FORCE" != true ]]; then
    echo "Error: $DST already exists and --force option not specified."
    exit 1
fi

# create $DST if it does not exist
if [[ ! -d "$DST" ]]; then
    echo "$DST does not exist; creating..."

    if ! mkdir -vp -- "$DST"; then
        echo "Error: failed to create directory"
        exit 1
    fi
fi

if [ ! -z "$(ls -A $DST)" ]; then
    echo "Error: directory is not empty"
    exit 1
fi

# Copy the configuration to the destination
if ! cp -a -- "$SRC/." "$DST"; then
  echo "Error: could not copy $SRC to $DST." >&2
  exit 1
fi

if ! ln -sfn -- "$INIT_FILE" "$INIT_LINK"; then
  echo "Error: could not link $INIT_LINK to $INIT_FILE"
  exit 1
fi

echo "OK: successfully installed the configuration at $DST and symlinked it to $INIT_LINK"
exit 0
