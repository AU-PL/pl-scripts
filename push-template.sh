#!/bin/bash
TEMPLATE=~/teaching/PL/student-repo-template
STUDENT_REPOS=~/teaching/PL/student-repos

# Main loop.
for i in $(ls $STUDENT_REPOS)
do
    # A [s]tudent [r]epo.
    SR=${STUDENT_REPOS}/$i
        
    # At this point the homework is ready to be copied.
    cp -vR $TEMPLATE/* ${SR}/
    
    # Commit the homework to Git.
    cd $SR
    git add .
    git commit -a -m "Updating the template files."
    git fetch
    git rebase
    git push
done
