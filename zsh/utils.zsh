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
