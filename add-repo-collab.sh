#!/bin/zsh

show_help() {
    cat << EOF
Usage: add-repo-collab.sh <csv_file> <repos_dir> <github_org> <github_token>

This script iterates through a CSV of names and usernames, searches for the name 
in the README.md of local repositories, and invites the matching username to the 
GitHub repository.

Arguments:
  <csv_file>      Path to the CSV file (Format: "Full Name,Username")
  <repos_dir>     Directory containing the local repositories

Assumes that the following environment variables are set:
  GITHUB_AT       GitHub Personal Access Token (must have repo permissions)

Example:
  ./add-repo-collab.sh students.csv ./repos MySchoolOrg

Options:
  -h, --help      Show this help message and exit
EOF
}

search_readme() {
    local repo_path="$1"
    local full_name="$2"
    local readme_file="$repo_path/README.md"

    if [[ -f "$readme_file" ]]; then
        # -F: Fixed string search (faster/safer than regex)
        # -q: Quiet (suppress output, just return exit code)
        if grep -Fq "$full_name" "$readme_file"; then
            return 0
        fi
    fi
    return 1
}

invite_collaborator() {
    local org="$1"
    local repo_name="$2"
    local username="$3"
    local token="$4"

    # Send PUT request to invite user
    # -o /dev/null: discard response body
    # -w "%{http_code}": only print the status code
    
    local status_code=$(curl -L \
        -X PUT \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $token" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/$org/$repo_name/collaborators/$username" \
        -o /dev/null -w "%{http_code}" -s)

    local status_code=201
    if [[ "$status_code" == "201" ]]; then
        echo "[SUCCESS] Invite sent: $username -> $org/$repo_name (Status: 201)"
    elif [[ "$status_code" == "204" ]]; then
        echo "[SUCCESS] Already added: $username -> $org/$repo_name (Status: 204)"
    else
        echo "[FAILURE] Could not invite: $username -> $org/$repo_name (Status: $status_code)"
    fi
}

process_invites() {
    local csv_path="$1"
    local repos_root="$2"
    local org="$3"
    local token="$4"

    echo "Starting collaborator invitation process..."
    echo "Organization: $org"
    echo "Searching in: $repos_root"
    echo "------------------------------------------------"

    while IFS="," read -r full_name github_username; do
        
        # Skip header or empty lines or comments
        [[ "$full_name" == "Full Name" ]] && continue
        [[ -z "$full_name" ]] && continue
        [[ "$full_name" =~ ^[[:space:]]*# ]] && continue

        full_name=$(echo "$full_name" | xargs)
        github_username=$(echo "$github_username" | xargs)
        
        for student_repo_path in "$repos_root"/*(/); do
            local repo_name=$(basename "$student_repo_path")

            if search_readme "$student_repo_path" "$full_name"; then
                invite_collaborator "$org" "$repo_name" "$github_username" "$token"
            fi
        done

    done < "$csv_path"

    echo "------------------------------------------------"
    echo "Process complete."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ "$#" -ne 2 ]]; then
    echo "Error: Invalid number of arguments provided."
    echo ""
    show_help
    exit 1
fi

CSV_FILE="$1"
REPOS_DIR="$2"
GH_ORG="AU-PL"

if [[ ! -f "$CSV_FILE" ]]; then
    echo "Error: CSV file '$CSV_FILE' does not exist."
    exit 1
fi

if [[ ! -d "$REPOS_DIR" ]]; then
    echo "Error: Repos directory '$REPOS_DIR' does not exist."
    exit 1
fi

process_invites "$CSV_FILE" "$REPOS_DIR" "$GH_ORG" "$GITHUB_AT"