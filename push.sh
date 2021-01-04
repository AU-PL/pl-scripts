#!/bin/bash

STUDENT_REPOS=~/teaching/CSCI-3300/student-repos/

# Main loop.
for i in $(ls $STUDENT_REPOS)
do
    # A [s]tudent [r]epo.
    SR=${STUDENT_REPOS}$i
    # Commit the homework to Git.
    cd $SR
    git pull --no-edit
    git push
done
