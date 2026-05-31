# Function to create and checkout a git branch based on a GitLab issue
issue() {
    local input=$1
    
    # Validate input is provided
    if [ -z "$input" ]; then
        echo "Error: Issue number or URL is required"
        echo "Usage: issue <issue_number_or_url>"
        return 1
    fi
    
    # Extract issue number from input
    local issue_number
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        issue_number=$input
    else
        issue_number="${input##*/}"
    fi
    
    git restore .
    git checkout master
    git pull --rebase
    local issue_title=$(glab issue view "$issue_number" --output json | jq -r '.title')
    local parameterized_title=$(rails runner "print ARGV[0].parameterize" "$issue_title")
    local branch_name="${issue_number}-${parameterized_title}"
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Branch '$branch_name' already exists. Switching to it and rebasing with origin/master..."
        git checkout "$branch_name"
        git rebase origin/master
    else
        echo "Creating new branch '$branch_name'..."
        git restore .
        git checkout -b "$branch_name"
    fi
    
    echo "Done! You are now on branch: $branch_name"
}

reset_cdot() {
    psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'payment_app_development' AND pid <> pg_backend_pid();"
    rails db:drop db:create; git restore .; make; git restore .; ./bin/setup; git restore .; make; git restore db/schema.rb;
    rails runner "Admin.update! password: 'withgreatpowercomesgreatresponsibility';"

}

alias initdb="mise exec postgres -- pg_ctl initdb -D ./db/postgresql; mise exec postgres -- pg_ctl start -D ./db/postgresql;"
