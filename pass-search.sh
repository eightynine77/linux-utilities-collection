#!/bin/bash

# this script only works on bitwarden json. if you want to make this script work for json exported from other
# password manager, then modify the jq line

# Hardcoded JSON file
JSON_FILE="/path/to/your/bitwarden/exported/json/bitwarden.json"  # Change this to the path of your exported bitwarden password

# Check if user provided search value
if [ -z "$1" ]; then
    cat $JSON_FILE
    echo ""
    echo ""
    echo ""
    echo "=================="
    echo "Usage: pass-search.sh <search_value>"
    echo ""
    echo "example: pass-search.sh youtube account"
    exit 1
fi

SEARCH_VALUE="$1"

# Check if file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File '$JSON_FILE' not found"
    exit 1
fi

echo "Searching for value: '$SEARCH_VALUE' in $JSON_FILE..."

jq --arg value "$SEARCH_VALUE" '
  .items[]
  | select(
      any(
        .. | strings;
        ascii_downcase | contains($value | ascii_downcase)
      )
    )
' "$JSON_FILE"
