#!/bin/bash

declare -a LocalBranches
pushd ~/src/utils-tools-misc
IFS=$'\n' LocalBranches=($(git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin)))


if [ ${#LocalBranches[@]} -eq 0 ]; then
    echo "No local-only branches found."
else
    for localBranch in "${LocalBranches[@]}"
    do
        branch=($(echo "$localBranch" | awk '{print $1}'))

        read -r -p "Delete the local branch [$branch]? [y/N] " response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
            git branch -d ${branch}
        else
            echo "Skipping [$branch]"
        fi
    done
fi