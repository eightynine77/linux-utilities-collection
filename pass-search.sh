#!/bin/bash

# Hardcoded JSON file
JSON_FILE="your_password_directory_here.json"  # Change this to your actual file name

# Check if user provided search value
if [ -z "$1" ]; then
    cat mypass
fi

SEARCH_VALUE="$1"

# Check if file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File '$JSON_FILE' not found"
    exit 1
fi

echo "Searching for value: '$SEARCH_VALUE' in $JSON_FILE..."

jq --arg value "$SEARCH_VALUE" '
    walk(
        if type == "object" or type == "array" then
            if tostring | test($value) then .
            else empty
            end
        else .
        end
    )
' "$JSON_FILE"
