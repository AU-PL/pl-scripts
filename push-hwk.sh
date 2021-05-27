#!/bin/bash
SEMESTER="Spring/2021"
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
        mkdir -p ${SR}/hwk    
    fi

    # If the homework is already in the students repo. move on.
    if [ -d "${SR}/hwk/$1" ]; then
        echo "Homework $1 already exists in $SR"
        continue
    fi
    
    # At this point the homework is ready to be copied.
    mkdir -p ${SR}/hwk/$1
    cp -vR $HWKORIG/* ${SR}/hwk/$1
    
    # Commit the homework to Git.
    cd $SR
    git add hwk/$1/*
    git commit -a -m "Added homework $1."
    git fetch
    git rebase
    git push
done
