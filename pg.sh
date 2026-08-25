#!/bin/bash

usage() {
    echo "Usage:"
    echo "  pg <website domain>"
    echo "  pg -list <file>"
    echo
    echo "Examples:"
    echo "  pg example.com"
    echo "  pg https://example.com"
    echo "  pg -list list_of_sites.txt"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

# -list argument is for pinging list of domains from a text file
if [ "$1" = "-list" ]; then
    if [ -z "$2" ]; then
        echo "Error: Missing file after -list"
        usage
    fi

    if [ ! -f "$2" ]; then
        echo "Error: File '$2' not found"
        exit 1
    fi

    while IFS= read -r line; do
        # Skip empty lines
        [ -z "$line" ] && continue

        # Strip http:// or https:// if present
        domain=$(echo "$line" | sed -E 's#^https?://##')

        echo "Pinging $domain..."
        ping -c 4 "$domain"
        echo
    done < "$2"
    exit 0
fi

# ping single domain if no argument provided
domain=$(echo "$1" | sed -E 's#^https?://##')
ping -c 4 "$domain"
