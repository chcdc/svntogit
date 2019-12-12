#!/bin/bash 

if [[ -z "$1" || -z "$2" ]] ;then
    echo "Argument Null. Exiting"
    exit 1
else
    if [[ $1 != http?(s)://svn/* || $2 != git@git* ]]; then
        echo -e "Invalid URL. Exiting"
        echo -e "Insira URL no seguinte formato:\n${0##*/} SVN GIT"
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
    mkdir -p ~/repo-$PROJECT
    mkdir -p ~/$PROJECT.git
    echo ""
    echo "Repositorios Criados"
}

function clone_repo_svn(){
    cd ~/repo-$PROJECT
    echo ""
    echo "Clonando repositorio SVN - $SVN"
    echo "---------------------------------------------"
    svn log --no-auth-cache -q $SVN | awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' | sort -u >authors-transform.txt
    cat authors-transform.txt
    time git svn clone $SVN --no-metadata -A authors-transform.txt --stdlayout
}

function git_config(){
    echo ""
    echo "Convertendo para GIT - $PROJECT"
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
      git tag "$ref" "origin/tags/$ref";
      git branch -D "origin/tags/$ref";
    done
}

function git_pull(){
    echo ""
    echo "Enviando para repositorio GIT - $REPO_GIT"
    echo "---------------------------------------------"
    cd ~/$PROJECT.git
    git remote add origin $REPO_GIT
    git push -u origin --all
    git push -u origin --tags
}

function main(){
    create_dirs
    clone_repo_svn
    git_config
    git_pull
}

main
