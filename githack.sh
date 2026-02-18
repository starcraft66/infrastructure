#!/bin/sh
# Save this as ~/bin/git (and ensure ~/bin is before /usr/bin in PATH)
# chmod +x ~/bin/git

if [ "$1" = "diff" ]; then
    # Insert --no-ext-diff before forwarding the rest
    command git diff --no-ext-diff "${@:2}"
else
    # Forward everything else untouched
    command git "$@"
fi
