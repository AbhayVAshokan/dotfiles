# Source all config files in the ~/.config/zsh folder
for config in ~/.config/zsh/*.zsh; do
  [ -r "$config" ] && source "$config"
done


# bun completions
[ -s "/Users/abhayvashokan/.bun/_bun" ] && source "/Users/abhayvashokan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
