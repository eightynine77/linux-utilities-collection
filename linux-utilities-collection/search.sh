#!/bin/bash
# ========================
# this bash script is for searching files and folders

LOCATION="/"

OPTIONS=$(getopt -o l: --long location: -- "$@")
if [ $? -ne 0 ]; then
    exit 1
fi

eval set -- "$OPTIONS"

while true; do
    case "$1" in
        -l|--location)
            LOCATION="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
    esac
done

if [ $# -eq 0 ]; then
    echo "Usage: search.sh [--location <directory>|-l <directory>] <search term>"
    echo "search.sh <search term>"
    echo ""
    echo "example: search.sh -l /home/user/Downloads readme.txt"
    echo 'search.sh -l "/home/user/camera files" selfie.png'
    echo "default search: search.sh program files"
    exit 1
fi

SEARCH_TERM="$*"

sudo find "$LOCATION" -xdev -iname "*$SEARCH_TERM*" -print 2>/dev/null
