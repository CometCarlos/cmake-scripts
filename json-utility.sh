#!bin/bash
# NOTE: These functions require JSON.sh from:
#   https://github.com/dominictarr/JSON.sh
# You must set the jsonLibraryPath global variable before using these functions.
# For example,
#   jsonLibraryPath="./libraries/JSON.sh/JSON.sh"

# -s = Silent Mode
# -S = Show errors when they occur (only when -s is used)
# 2>&1 = Redirect stderr to stdout (to see the result in our testData variable below)
# testData="$(curl -sS https://registry.npmjs.org/express 2>&1)"

# Sets a global Bash array called lastJSONArray from the JSON.sh split output.
function getJSONArray() {
    local jsonText="$1"
    local arrayName="$2"
    jsonSplit="$(echo "$jsonText" | "$jsonLibraryPath")"

    lastJSONArray=()
    regex="\\[\"$arrayName\",[0-9]+\][[:space:]]*\"(.*)\""
    while IFS= read -r line; do
        if [[ "$line" =~ $regex ]]; then
            lastJSONArray+=("${BASH_REMATCH[1]}")
        fi
    done <<< "$jsonSplit"
}
