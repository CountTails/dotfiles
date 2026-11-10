#! /bin/bash


SRC="$(git rev-parse --show-toplevel)/vim/config/init.vim"
DST="$HOME/.config/vim"
LINK="$HOME/.vimrc"
FORCE=false

# Parse the `--force` option
case "${1:-}" in
--force)
  FORCE=true
  shift
  ;;
esac

# create $DST if it does not exist
if [[ ! -d "$DST" ]]; then
  echo "$DST does not exist; creating..."

  if ! mkdir -vp -- "$DST"; then
    echo "Error: failed to create directory"
    exit 1
  fi
fi

# Check for an existing ~/.vimrc and bail if force is not specified
if [[ -L $LINK && "$FORCE" != true ]]; then
  echo "Error": $LINK exists and --force option not specified
  exit 1
fi

# Check that the target exists and stop if `--force` is not specified
if [[ -f "$DST" && "$FORCE" != true ]]; then
  echo "Error: $DST already exists and --force option not specified."
  exit 1
fi

if [ ! -z "$(ls -A $DST)" ]; then
  echo "Error: directory is not empty"
  exit 1
fi

# Copy the configuration to the destination
if ! cp -- "$SRC" "$DST"; then
  echo "Error: could not copy $SRC to $DST." >&2
  exit 1
fi

if ! ln -sfn -- "$DST/init.vim" "$LINK"; then
  echo "Error: could not link $LINK to $DST/init.vim"
  exit 1
fi

echo "OK: successfully installed the configuration at $DST and symlinked it to $LINK"
exit 0
