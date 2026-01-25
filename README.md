# Personal Dotfiles & Configurations

This repository contains my personal configuration files for various command-line tools and applications. It's managed as a Git repository to track changes and synchronize my setup across different machines.

## Codebase Overview

This collection of dotfiles configures my primary development environment. Here's a breakdown of the key components:

### Shell Configuration: Zsh

- **`.zshrc`**: The main configuration file for the Zsh shell. It sources other files and sets up the initial environment.
- **`zsh/`**: This directory contains the bulk of the shell customization, broken into logical files:
  - `alias.zsh`: Common command aliases for efficiency.
  - `plugins.zsh`: Manages Zsh plugins.
  - `fzf.zsh`, `gitlab.zsh`, `notion.zsh`: Specific configurations for integrations with tools like fzf, GitLab, and Notion.
  - `custom.zsh`, `tools.zsh`, `utils.zsh`: Custom functions, tool settings, and utility helpers.

### Neovim Configuration

- **`nvim/`**: Contains my complete Neovim setup. This is managed as a separate project in its own Git repository and included here as a **Git submodule**.
- **Repository**: You can find the full Neovim configuration here: [https://gitlab.com/abhayvashokan/abhay-nvim.git](https://gitlab.com/abhayvashokan/abhay-nvim.git)

### Git Configuration

- **`.gitconfig`**: Defines my global Git user information, aliases, and default behaviors.

### Other Tools

This repository also manages configurations for several other tools:

- **`.tmux.conf`**: Configuration for the `tmux` terminal multiplexer, defining keybindings and status bar appearance.
- **`ghostty/config`**: Settings for the Ghostty terminal emulator.
- **`mise/config.toml`**: Configuration for the `mise` (formerly `rtx`) polyglot runtime manager.
- **`neofetch/config.conf`**: Settings for `neofetch`, a system information tool.
- **`pgcli/config`**: Configuration for the `pgcli` PostgreSQL client.
- **`.pryrc`**: Configuration for `pry`, an IRB alternative for Ruby.
