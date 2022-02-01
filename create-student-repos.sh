#!/bin/zsh

IFS=','
csvfile=$1

repo_dir=/Users/heades/teaching/PL/student-repos
template_repo=/Users/heades/teaching/PL/template-repo

# Check to make sure the file exists:
[ ! -f $csvfile ] && { echo "$csvfile file not found"; exit 99; }

function create_repo() {
    readonly sid=${1:?"Student id must be specified."}
    readonly repo=$repo_dir/$sid
    [ -d $repo ] && { echo "$repo already exists."; exit 99; }    

    # Create the repo:
    mkdir $repo
}

function setup_repo() {
    readonly sid=${1:?"Student id must be specified."}
    readonly repo=$repo_dir/$sid
    [ ! -d $repo ] && { echo "$repo not found."; exit 99; }    
    readonly git_origin="git@github.com:AU-PL"

    # Enter the repo:
    cd $repo

    # Setup the repo with the Github Org:
    git init .        
    git remote add origin "$git_origin/$sid.git"    
}

function create_readme() {
    readonly sid=${1:?"Student id must be specified."}
    readonly name=${2:?"Student name must be specified."}
    
    readonly repo=$repo_dir/$sid
    [ ! -d $repo ] && { echo "$repo not found."; exit 99; }    

    contents="# $name's Private Repo\n\nAll assignments will be turned in through this repo. In addition, all feedback will be given back to you through this repo.\n\nHomework will appear in a directory called hwk, but this will only appear after the first homework is released."
    
    readme_path="$repo/README.md"
    echo $contents > $readme_path
    cd $repo
    git add README.md
    git commit -a -m 'Adding the README'
}

function copy_template_repo() {
    readonly sid=${1:?"Student id must be specified."}
    readonly repo=$repo_dir/$sid
    [ ! -d $repo ] && { echo "$repo not found."; exit 99; }    

    # Add the template repo's files:
    rsync -rP --exclude="README.md" --exclude="*~" $template_repo/* $repo
    cd $repo
    git add .
    git commit -a -m 'Adding the template files.'
}

function create_repo_github() {
    readonly sid=${1:?"Student id must be specified."}
    readonly name=${2:?"Student name must be specified."}
    
    org_url="https://api.github.com/orgs/AU-PL/repos"    

    read -r -d '' data <<EOF 
{
  "accept": "application/vnd.github.v3+json",
  "name": "$sid",
  "description": "$name's Private Repo",
  "private": "true"
}
EOF
    echo "curl -X POST -H \"Authorization: token $GITHUB_AT\" $org_url --data $data"
    curl -X POST -H "Authorization: token $GITHUB_AT" $org_url --data $data 
}

function push_repo() {
    readonly sid=${1:?"Student id must be specified."}
    readonly repo=$repo_dir/$sid
    [ ! -d $repo ] && { echo "$repo not found."; exit 99; }
    
    cd $repo
    git branch -M main
    git push -u origin main
}

# Read each cell from the $csvfile:
while read -s first last sid email
do
    name="$first $last"
    echo "=== Creating $name's repo ==="
    create_repo        $sid       &&
    setup_repo         $sid       &&
    create_readme      $sid $name &&
    copy_template_repo $sid       &&
    create_repo_github $sid $name &&
    push_repo          $sid
    echo "=============================\n\n"
done < $csvfile
