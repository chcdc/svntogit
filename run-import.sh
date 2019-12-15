#!/bin/bash 

if [[ -z "$1" || -z "$2" ]] ;then
    echo "Argument Null. Exiting"
    exit 1
else
    if [[ $1 != http?(s)://svn/* || $2 != git@git* ]]; then
        echo -e "Invalid URL. Exiting"
        echo -e "How to insert parameters:\n${0##*/} SVN GIT"
        exit 1
    else
        SVN=$1
        REPO_GIT=$2
    fi
fi

alias svn="svn --non-interactive --trust-server-cert"
PROJECT=${SVN##*/}

function create_dirs(){
    echo ""
    echo "Creating Directories $PROJECT"
    echo "---------------------------------------------"
    if [ -d ~/$PROJECT.git ]; then
        echo -e "Removing old directories | $PROJECT.git"
        rm -rf ~/$PROJECT.git
    fi
    if [ -d ~/repo-$PROJECT ]; then
        echo -e "Removing old directories  | repo-$PROJECT"
        rm -rf ~/repo-$PROJECT
    fi
    mkdir -p ~/repo-$PROJECT
    mkdir -p ~/$PROJECT.git
    if [ $? -eq 0 ]; then
        echo "Directories created"
        clone_repo_svn
    fi
}

function clone_repo_svn(){
    cd ~/repo-$PROJECT
    echo ""
    echo "Cloning repositories SVN - $SVN"
    echo "---------------------------------------------"
    svn log --no-auth-cache -q $SVN | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u >authors-transform.txt
    echo ""
    time git svn clone $SVN --no-metadata -A authors-transform.txt --stdlayout 
    if [ $? -eq 1 ]; then
        echo -e "Error cloning repositories\n"
        exit 1
    else
        git_config
    fi
}


function git_config(){
    echo ""
    echo "Convert to GIT - $PROJECT"
    echo "---------------------------------------------"
    cd ~/$PROJECT.git
    git init --bare
    git symbolic-ref HEAD refs/heads/trunk
    cd ~/repo-$PROJECT/$PROJECT
    git remote add bare ~/$PROJECT.git/
    git config remote.bare.push 'refs/remotes/*:refs/heads/*'
    git push bare
    cd ~/$PROJECT.git/
    git branch -m origin/trunk master
    git for-each-ref --format='%(refname)' refs/heads/origin/tags | 
    cut -d / -f 5 |
    while read ref
    do
      echo $ref
      echo ""
      git tag "$ref" "origin/tags/$ref";
      git branch -D "origin/tags/$ref";
    done
    git_pull
}

function git_pull(){
    echo ""
    echo "Push GIT - $REPO_GIT"
    echo "---------------------------------------------"
    cd ~/$PROJECT.git
    git remote add origin $REPO_GIT
    git push -u origin --all
    git push -u origin --tags
}

function main(){
    create_dirs
}

main
