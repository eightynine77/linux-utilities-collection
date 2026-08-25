#!/bin/bash

#edit files in sudo mode

if [ -z "$1" ]; then
    echo "Usage: sudoxed <the file you want to edit>"
    echo
    echo "example: sudoxed file.txt"
    exit 1
fi

sudo xed "$1" #replace xed with your preferred text editor (i.e vim, emacs, etc)
