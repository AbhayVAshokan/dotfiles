# colors for man pages
man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;35m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
	  LESS_TERMCAP_us=$(printf '\e[04;33m') \
		man "$@"
}

# Added by GDK bootstrap
eval "$(/opt/homebrew/bin/mise activate zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/abhayvashokan/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/abhayvashokan/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/abhayvashokan/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/abhayvashokan/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

