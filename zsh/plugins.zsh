# zcomet plugin manager
if [[ ! -f ~/.config/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git ~/.config/.zcomet/bin
fi

source ~/.config/.zcomet/bin/zcomet.zsh

zcomet load agkozak/zsh-z
zcomet load ohmyzsh plugins/git

if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then

  zcomet load zsh-users/zsh-autosuggestions
  zcomet load zsh-users/zsh-syntax-highlighting
fi

zcomet compinit
