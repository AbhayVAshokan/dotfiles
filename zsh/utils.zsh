# kill a process running at a particuar port.
fucku() {
	if [[ $# -ne 1 ]]; then
	  echo "Usage: fucku <pattern>"
	  return 1
	fi
	
	kill $(lsof -t -i:$1)
}
