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
    git push
};

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
    git pull;
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
