#!/bin/bash
SEMESTER="Spring/2021"
HWKORIG=~/teaching/PL/quizzes/$SEMESTER/$1
STUDENT_REPOS=~/teaching/PL/student-repos

IFS=','
csvfile=~/teaching/PL/admin/Spring/2021/covid-list.csv

if [ -z "$1" ]; then
    echo "The first argument to this script is the quiz number."
    exit 0
fi

if [ -z "$2" ]; then
    echo "The second argument to this script is the day."
    exit 0
fi

# Main loop.
while read -s first last sid email day
do
    echo $last
    [ "$day" != "$2" ] && continue
    
    # A [s]tudent [r]epo.
    SR=${STUDENT_REPOS}/$sid
    
    # If the quiz is already in the students repo. move on.
    if [ -d "${SR}/quiz/$1" ]; then
        echo "Quiz $1 already exists in $SR"
        continue
    fi
    
    # At this point the homework is ready to be copied.
    mkdir -p ${SR}/quiz/$1
    cp -vR $HWKORIG/*.pdf ${SR}/quiz/$1/
    
    # Commit the homework to Git.
    cd $SR
    git add quiz/$1/*.pdf
    git commit -a -m "Added Quiz $1."
    git pull --no-edit
    git push
done < ${csvfile}
