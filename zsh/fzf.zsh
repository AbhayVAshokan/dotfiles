	export FZF_DEFAULT_COMMAND='fd --type f --hidden'
	export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border --preview "bat --style=numbers --color=always {}"'
	export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
	export FZF_ALT_C_OPTS='--preview "tree -C {} | head -n 500"'
	export PATH="$PATH:${FZF_PATH}/bin"
	 
	source <(fzf --zsh)

	# Execute a command using fzf.
	# Usage f: Opens the selected file in neovim.
	# Usage f <command>: Executes the <command> on the selected file.
	f() {
	  local command="nvim"
	 
	  if [[ $# -gt 0 ]]; then
	    command="$@"
	  fi
	 
	  fzf --bind "enter:become(${command} {})"
	}
