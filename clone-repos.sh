# Requires one command-line argument that is the path to a text file
# containing the name of each repo one per line.  For example,
# repos.txt could contain:
#       repo1
#       repo2
#       repo3
#       ...
#!/bin/bash

STUDENT_REPOS=~/teaching/CSCI-3300/student-repos

CLONE_URL=git@gitlab.metatheorem.org:CSCI3300

while read repo
do
    git clone $CLONE_URL/$repo $STUDENT_REPOS/$repo
done < $1
