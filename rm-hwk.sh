#!/bin/bash
SEMESTER="Spring/2025"
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
        echo "No homework to remove."
        exit 0;
    fi

    if [ -d "${SR}/hwk/$1" ]; then
        rm -rf ${SR}/hwk/$1
        # Commit the homework to Git.
        cd $SR
        git add hwk/.
        git commit -a -m "Removing homework $1."
        git fetch
        git rebase
        git push  
    fi
done
