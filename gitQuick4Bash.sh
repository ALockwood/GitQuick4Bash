#!/bin/bash

#Misc Helpers
function ErrorMessage() {
    echo -e "\033[1;31m$1\033[0m"
}
#End Misc Helpers

#GitStatus
function gs() {
    git status
}

#Git Push
function push() {
    pushresult="$(git push 2>&1)"
    status=$?
    if [ $status -eq 0 ]; then
        echo "$pushresult"
        return 0
    else
        #Check the output to see if it's got "git push --set-upstream" in it
        if [[ "$pushresult" = *"git push --set-upstream"* ]]; then
            pushcmd=$(echo "$pushresult" | sed -n "/git push --set-upstream/p")
            if [[ ! -z "$pushcmd" ]]; then
                cmd=${pushcmd##*( )}
                read -p "Press anything to execute [$cmd], CTRL-C to cancel..."
                $cmd
                return $?
            fi
        else
            echo "Unhandled git push result..."
            echo "$pushresult"
            return 1
        fi
    fi
}

#GiterDone
#Stages "all the things" and adds a message
function giterdone() {
    if [ $# -eq 0 ] 
        then 
            ErrorMessage "A commit message must be supplied. Showing current branch status..."
            git status -s
            return 1
    fi

    git status -s && git add -A && git commit -m "$1"
};

#GitRemoteStatus
function gbs() {
    git remote show origin
};

#Git Pull
function pull() {
    git pull -v
};

#GitNewBranch
function gb() {
    if [ $# -eq 0 ] 
        then 
            ErrorMessage "You must supply a new branch name!"
            return 1
    fi

    git checkout -b $1
};

#GitCleanMergeFiles
function cmf() {
    git clean -f *.orig
};

#GitlogPretty
function glp() {
    git log --graph --decorate --oneline --pretty='format:%C(dim white)%h%Creset - %C(bold green)(%cr)%Creset %C(bold yellow)%d%Creset%n    %C(white bold)%s%Creset%C(white dim) - %an%Creset'
};

#GitHardSwitch
function gitswitch {
     if [ $# -eq 0 ] 
        then 
            ErrorMessage "You must supply a branch name for checkout!"
            return 1
    fi

    git checkout $1 -f;
    git fetch origin;
    git clean -fdx; #kiss your local files goodbye
    git reset --hard origin/$1;
    git pull -v;
}

#Git Prune
function gitprune {
    if [ "$1" == "run" ];
        then
            git remote prune origin
        else
            echo "Use 'gitprune run' to prune..."
            git remote prune origin --dry-run
    fi
}

#Git Refresh
#Use this to refresh (fetch latest) a branch other than your currently active branch.
#Useful for refreshing a dev branch prior to merging into an active feature branch.
function gitrefresh {
    if [ $# -eq 0 ]
        then
            ErrorMessage "A branch name must be supplied for refresh!"
            return 1
    fi

    git fetch -v origin $1:$1
}


#Git Delete Local Branches
#Useful for cleaning up local repositories where remote branches have been deleted.
#Note: This may list local branches that haven't been pushed. Use with caution.
function gitdlb {
    declare -a LocalBranches
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
}