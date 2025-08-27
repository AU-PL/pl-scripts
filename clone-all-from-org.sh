#!/bin/bash

student_repos=/Users/heades/work/teaching/PL/student-repos

cd ${student_repos}
echo $GITHUB_AT
curl -s -H "Authorization: token $GITHUB_AT" https://api.github.com/orgs/AU-PL/repos\?per_page\=200 | jq '.[].ssh_url' | xargs -n 1 git clone
