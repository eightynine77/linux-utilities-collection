#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: search.sh <search query>"
    echo ""
    echo "for example: search.sh the walking cat"
    exit 1
fi

sudo find / -xdev -iname "*$*" -print 2>/dev/null
