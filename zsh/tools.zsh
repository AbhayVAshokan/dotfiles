# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# mise
eval "$(mise activate zsh)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# NOTE:
#
# postgresql via mise
# The following error is thrown while executing the `mise install` command.
# If you have ICU already installed, see config.log for details on the
# failure.  It is possible the compiler isn't looking in the proper directory.
# Use --without-icu to disable ICU support.
# mise ERROR Failed to install asdf:postgres@17.2: 
#    0: ~/.local/share/mise/plugins/postgres/bin/install exited with non-zero status: exit code 1

# To fix this issue, add the following two flags before executing the command:
# `MACOSX_DEPLOYMENT_TARGET=15.4.0 mise install postgres`
# https://github.com/smashedtoatoms/asdf-postgres/issues/28#issuecomment-912566724
#
# export ICU_CFLAGS="-I$(brew --prefix icu4c)/include"
# export ICU_LIBS="-L$(brew --prefix icu4c)/lib -licui18n -licuuc -licudata"
export PKG_CONFIG_PATH="$(brew --prefix icu4c)/lib/pkgconfig" \
export LDFLAGS="-L$(brew --prefix icu4c)/lib" \
export CPPFLAGS="-I$(brew --prefix icu4c)/include" \

# Use oh-my-posh prompt for vscode
# theme: star
# if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then
    eval "$(oh-my-posh init zsh --config 'https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/amro.omp.json')"
# fi

# Adds a small margin before the next prompt.
precmd() { echo }
