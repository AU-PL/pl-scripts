#!/bin/bash
SEMESTER="Fall/2025"
HWKORIG=~/teaching/PL/hwk/$SEMESTER/$1/student
STUDENT_REPOS=~/teaching/PL/student-repos/

if [ -z "$1" ]; then
    echo "The first argument to this script is the homework number."
    exit 0
fi

# Main loop.
for i in $(ls $STUDENT_REPOS)
do
    # A [s]tudent [r]epo.
    SR=${STUDENT_REPOS}$i
    
    # Check to see if any homework has been added to the current SR.
    if [ ! -d "${SR}/hwk" ]; then
        echo "The hwk directory is missing in $SR"
        continue
    fi
    
    # If the homework is already in the students repo. move on.
    if [ -d "${SR}/hwk/$1" ]; then
        echo "Updating Homework $1 in $SR"        
    else 
        echo "The directory hwk/$1 is missing $SR."
        continue
    fi
    # Copy the contents (this will update existing files):
    cp -vR $HWKORIG/* ${SR}/hwk/$1

    # Commit the homework to Git.
    cd $SR
    git add hwk/$1/*
    git commit -a -m "Added homework $1."
    git fetch
    git rebase
    git push
done
