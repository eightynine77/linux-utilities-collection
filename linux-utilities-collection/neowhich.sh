#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: neowhich <file-or-folder>"
    exit 1
fi

if [ -f "$1" ]; then
    echo "Full path to file:"
    echo "$(realpath "$1")"

elif [ -d "$1" ]; then
    echo "Full path to directory:"
    echo "$(realpath "$1")"

else
    echo "Error: '$1' is not a valid file or directory."
    exit 1
fi
