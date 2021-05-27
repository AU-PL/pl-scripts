#!/bin/bash

STUDENT_REPOS=~/teaching/PL/student-repos/

# Main loop.
for i in $(ls $STUDENT_REPOS)
do
    # A [s]tudent [r]epo.
    SR=${STUDENT_REPOS}$i
    cd $SR; git pull --no-edit
done
