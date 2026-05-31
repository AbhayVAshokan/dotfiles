# kill a process running at a particuar port.
fucku() {
	if [[ $# -ne 1 ]]; then
	  echo "Usage: fucku <pattern>"
	  return 1
	fi
	
	kill $(lsof -t -i:$1)
}

# Simulates traffic using curl command.
# Sends requests one after another sequentially without waiting for the response.
# Checkout simular-traffic-ab to see how to bring concurrency which is what typically
# real world presents.
#
# simulate_traffic <url> <requests_per_minute>
#
# simulate_traffic https://neeto.com 100
simulate_traffic() {
	# Check if both arguments are provided
	if [ -z "$1" ] || [ -z "$2" ]; then
  	echo "Usage: $0 <url> <requests_per_minute>"
  	echo "Example: $0 https://spinkart.neetoform.net/f2f3985bcf5fc294fe61 100"
  	exit 1
	fi

	URL="$1"
	REQUESTS_PER_MINUTE=$2

	# Validate that the argument is a positive number
	if ! [[ "$REQUESTS_PER_MINUTE" =~ ^[0-9]+$ ]] || [ "$REQUESTS_PER_MINUTE" -le 0 ]; then
  	echo "Error: requests_per_minute must be a positive integer"
  	exit 1
	fi

	INTERVAL=$(echo "scale=4; 60 / $REQUESTS_PER_MINUTE" | bc)

	echo "Simulating traffic: $REQUESTS_PER_MINUTE requests per minute to $URL"
	echo "Interval between requests: ${INTERVAL}s"
	echo "Press Ctrl+C to stop"
	echo ""

	# Cleanup background jobs on exit
	trap 'kill $(jobs -p) 2>/dev/null; exit' SIGINT SIGTERM

	COUNT=0
	START_TIME=$(date +%s)

	# Function to send a single request
	send_request() {
  	local request_num=$1
  	local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  	local http_code=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  	echo "[$timestamp] Request #$request_num - HTTP Status: $http_code"
	}

	while true; do
  	COUNT=$((COUNT + 1))

  	# Send request in background to avoid blocking
  	send_request $COUNT &

  	# Calculate next request time to maintain accurate rate
  	NEXT_TIME=$(echo "$START_TIME + ($COUNT * $INTERVAL)" | bc)
  	CURRENT_TIME=$(date +%s.%N)
  	SLEEP_TIME=$(echo "$NEXT_TIME - $CURRENT_TIME" | bc)

  	# Only sleep if we're ahead of schedule
  	if (( $(echo "$SLEEP_TIME > 0" | bc -l) )); then
    	sleep "$SLEEP_TIME"
  	fi
	done
}

# Start development server using overmind
server() {
	overmind start -f Procfile &
}

# Tmux session management
# Usage: t <session-name>
# Opens existing tmux session or creates a new one with nvim and server windows
t() {
	if [[ $# -ne 1 ]]; then
		echo "Usage: t <session-name>"
		return 1
	fi
	
	local session_name="$1"
	
	# Check if session already exists
	if tmux has-session -t "$session_name" 2>/dev/null; then
		# Session exists - attach and switch to first window
		tmux attach-session -t "$session_name" \; select-window -t 1
	else
		# Session doesn't exist - create it
		# Create session with first window running nvim
		tmux new-session -d -s "$session_name" -n "nvim" nvim
		
		# Create second window for server
		tmux new-window -t "$session_name:2" -n "server" "zsh -c 'source ~/.zshrc && server; exec zsh'"
		
		# Switch back to first window and attach
		tmux select-window -t "$session_name:1" \; attach-session -t "$session_name"
	fi
}

# Show the diff of everything you haven't pushed yet.
gunpushed() {
	branch=$(git rev-parse --abbrev-ref HEAD)
	git diff origin/$branch..HEAD
}

# Show all gitlab todos
todos() {
  glab todo list --output=json "$@" \
    | jq -r '
        .[] | [
          .target_url,
          .target_type,
          (
            ("@" + (.author.username // "someone")) as $who
            | (
                if   .action_name == "mentioned"          then "\($who) mentioned you"
                elif .action_name == "directly_addressed" then "\($who) addressed you"
                elif .action_name == "assigned"           then "\($who) assigned this to you"
                elif .action_name == "review_requested"   then "\($who) requested your review"
                elif .action_name == "marked"             then "\($who) marked for you"
                elif .action_name == "approval_required"  then "\($who) needs your approval"
                elif .action_name == "build_failed"       then "build failed (\($who))"
                else "\($who) \(.action_name)"
                end
              ) as $prefix
            | (.body // "" | gsub("\\s+"; " ")) as $full
            | (if ($full | length) > 120 then ($full[0:120] + "...") else $full end) as $msg
            | ($prefix + ":") as $head
            | (if ($head | length) >= 40
               then $head + " "
               else $head + (" " * (40 - ($head | length)))
               end) as $padded
            | if ($msg | length) > 0 then "\($padded)\($msg)"
              else "\($prefix) — \(.target.title // "")"
              end
          )
        ] | @tsv' \
    | awk -F'\t' '{printf "%s\t%-15s  %s\n", $1, $2, $3}' \
    | fzf --no-preview \
          --delimiter=$'\t' \
          --with-nth=2 \
          --header="$(printf '%-15s  %s' 'TYPE' 'MESSAGE')" \
          --bind 'enter:execute-silent(open {1})+abort'
}

mrs() {
  local me
  me=$(glab auth status 2>&1 | awk -F'[: ]+' '/Logged in to .* as/ {print $NF}' | head -n1)
  me="${me:-$GITLAB_USER}"
  if [[ -z "$me" ]]; then
    echo "Could not resolve your GitLab username. Set \$GITLAB_USER or run \`glab auth login\`." >&2
    return 1
  fi
  local fmt='
    if length == 0 then "  (none)"
    else
      .[] | "  [\(.references.full)] @\(.author.username): \(.title)\n    \(.web_url)"
    end
  '
  echo "## Returned to you"
  glab api --paginate "merge_requests?scope=created_by_me&state=opened&reviewer_state=requested_changes" \
    | jq -r "$fmt"
  echo
  echo "## Review requested"
  glab api --paginate "merge_requests?reviewer_username=${me}&state=opened&scope=all" \
    | jq -r "$fmt"
  echo
  echo "## Your merge requests"
  glab api --paginate "merge_requests?scope=created_by_me&state=opened" \
    | jq -r "$fmt"
  echo
  echo "## Waiting for author or assignee"
  glab api --paginate "merge_requests?reviewer_username=${me}&state=opened&reviewer_state=reviewed&scope=all" \
    | jq -r "$fmt"
  echo
  echo "## Waiting for approvals"
  glab api --paginate "merge_requests?scope=created_by_me&state=opened" \
    | jq -r '
        [.[] | select(.upvotes == 0)] as $pending
        | if ($pending | length) == 0 then "  (none)"
          else $pending[] | "  [\(.references.full)] @\(.author.username): \(.title)\n    \(.web_url)"
          end'
  echo
  echo "## Approved by you"
  glab api --paginate "merge_requests?approved_by_usernames=${me}&state=opened&scope=all" \
    | jq -r "$fmt"
  echo
  echo "## Approved by others"
  glab api --paginate "merge_requests?scope=created_by_me&state=opened" \
    | jq -r '
        [.[] | select(.upvotes > 0)] as $approved
        | if ($approved | length) == 0 then "  (none)"
          else $approved[] | "  [\(.references.full)] @\(.author.username): \(.title)\n    \(.web_url)"
          end'
}
