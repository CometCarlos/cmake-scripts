#!/bin/bash
# This script checks all the folders between the current folder (pwd) and the folder containing
# All of the cmake-scripts (not including the cmake-scripts folder),
# To find the first CMakeLists.txt.

thisScriptFolder="$(dirname "${BASH_SOURCE[0]}")"
source "$thisScriptFolder/get-platform.sh" --silent
source "$thisScriptFolder/get-relative-path.sh"

# EX: "PixelEngine/cmake-scripts"
relativePath="$(getRelativePath "$(pwd)" "$thisScriptFolder")"

cmakeFolder=""
cmakeFile=""
foundCMakeLists=false
function checkForCMake() {
    local currentPath="$1"

    local possibleCMakeFile="$currentPath/CMakeLists.txt"
    if [ -f "$possibleCMakeFile" ]; then
        foundCMakeLists=true
        cmakeFile="$possibleCMakeFile"
        cmakeFolder="$(dirname $cmakeFile)"
    fi
}

# NOTE: relativePath does NOT have a trailing slash (/), so we'll never check the cmake-scripts folder (good!).
relativePathLength=${#relativePath}
for ((i=0; i<$relativePathLength; i++)); do
    currentChar="${relativePath:$i:1}"

    # NOTE: printf "-" will trick printf, thinking you're trying to pass an option, and then it'll error out.
    # To make sure this line only treats $currentChar as a string literal, we use %s like so:
    # printf "%s " "$currentChar"

    if [[ "$currentChar" = "/" ]]; then
        nextFolder="${relativePath:0:$i}"
        checkForCMake "$nextFolder"
    fi
done
