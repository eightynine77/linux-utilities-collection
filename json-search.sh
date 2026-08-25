#!/bin/bash

JSON_FILE="/path/to/your/json_file.json"  

if [ -z "$1" ]; then
    echo "Usage: json-search <search_value>"
    exit 1
fi

SEARCH_VALUE="$1"

# check if file exists
if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File '$JSON_FILE' not found"
    exit 1
fi

echo "searching for value: '$SEARCH_VALUE' in $JSON_FILE..."

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

# ============================================================================================
#  this script version with arguments (meaning that you don't have to hardcode your json file)
# ============================================================================================

#!/bin/bash

## check if user provided search value and file
# if [ $# -lt 2 ]; then
#     echo "Usage: $0 <search_value> <json_file>"
#     exit 1
# fi

# SEARCH_VALUE="$1"
# JSON_FILE="$2"

## check if file exists
# if [ ! -f "$JSON_FILE" ]; then
#     echo "Error: File '$JSON_FILE' not found"
#     exit 1
# fi

# echo "Searching for value: '$SEARCH_VALUE'..."

# jq --arg value "$SEARCH_VALUE" '
#     walk(
#         if type == "object" or type == "array" then
#             if tostring | test($value) then .
#             else empty
#             end
#         else .
#         end
#     )
# ' "$JSON_FILE"
