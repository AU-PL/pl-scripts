curl -s -H "Authorization: token $GITHUB_AT" https://api.github.com/orgs/CSCI3300-PL-Concepts/repos\?per_page\=200 | jq '.[].ssh_url' | xargs -n 1 git clone
