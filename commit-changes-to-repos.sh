#!/bin/zsh

student_repos="/Users/heades/work/teaching/PL/student-repos/*"

for dir in ${student_repos}; do
    cd $dir    
    git add .
    git commit -a -m 'Some updates.'
    git fetch && git rebase
    git push
done