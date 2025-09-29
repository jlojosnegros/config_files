# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal dotfiles repository that manages development tool configurations using GNU Stow for symlink-based deployment. The repository contains configurations for Neovim, Git, Tmux, Zsh, GDB, LazyGit, and other development tools.

## Stow-based Configuration Management

All configurations are deployed using `stow` to create symlinks. The general pattern is:

```bash
# Deploy configuration
stow -v -d /home/jojosneg/source/mine/config_files/ -t TARGET_DIR PACKAGE_NAME

# Remove configuration
stow -v -d /home/jojosneg/source/mine/config_files/ -t TARGET_DIR -D PACKAGE_NAME
```

### Common deployment commands:
- Neovim: `stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim nvim`
- Tmux: `stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux tmux`
- Zsh: `stow -v -d /home/jojosneg/source/mine/config_files/linux_shell -t /home/jojosneg zsh`
- Git: `stow -v -d /home/jojosneg/source/mine/config_files -t /home/jojosneg git`

## Architecture

### Directory Structure
- `nvim/` - Primary Neovim configuration with Lazy.nvim package manager
- `nvim_nvchad/` - Alternative NvChad-based Neovim setup
- `git/` - Git configuration with multi-context identity profiles
- `tmux/` - Tmux terminal multiplexer configuration
- `lazygit/` - LazyGit TUI configuration
- `linux_shell/` - Shell configurations (bash, zsh) with Zinit plugin manager
- `gdb/` - GDB debugger configuration
- `.vscode/` - VS Code workspace settings

### Multi-Context Git Configuration
Git is configured with conditional includes for different working contexts:
- RedHat work profile for `/home/jojosneg/source/redhat/` directory
- Personal GitHub profile for general use
- GitLab profile for specific projects

The configuration uses P4Merge for diff/merge operations and includes extensive alias collections.

### Neovim Ecosystem
The repository maintains two separate Neovim configurations:
- **nvim/**: Custom configuration using Lazy.nvim with extensive plugin ecosystem
- **nvim_nvchad/**: NvChad-based configuration for alternative workflow

Key Neovim features:
- LSP integration for multiple languages
- Debugging support via nvim-dap
- Git integration with gitsigns and fugitive
- File exploration with nvim-tree
- Theme support with multiple colorschemes

#### NvChad Configuration (nvim_nvchad/)
This setup uses NvChad v2.5 as a base plugin with custom extensions:

**Language Development Profiles:**
- Profile system automatically switches based on file type (lua/profiles/)
- C/C++ profile: Bazel build system integration, clang-format, clangtidy
- Rust profile: Cargo integration, rustfmt, clippy
- Profiles handle build (`<leader>pb`), test (`<leader>pt`), debug (`<leader>pd`)

**Code Quality Tools:**
- Formatting: conform.nvim with format-on-save (toggleable via `<leader>cF`/`<leader>cG`)
- Linting: nvim-lint with real-time feedback
- Markdown: markdownlint-cli2 + prettier integration with custom rules

**Key Bindings Organization:**
- `<leader>s*`: Search operations (Telescope)
- `<leader>g*`: Git operations (gitsigns + Telescope)
- `<leader>c*`: Code operations (LSP, format, lint)
- `<leader>d*`: Debug operations (nvim-dap)
- `<leader>p*`: Profile management
- `<leader>b*`: Buffer navigation
- `<leader>j*`: Jump operations with position memory
- `<leader>lg`: LazyGit in floating window

**Python Provider Setup:**
Requires Python venv at `~/.venvs/neovim` with pynvim installed for full functionality.

### Shell Environment
Zsh configuration includes:
- Zinit plugin manager for performance
- Powerlevel10k prompt theme
- Zoxide for intelligent directory navigation
- Go development environment (version 1.22.1 via gimme)

## Common Development Commands

### NvChad Configuration Commands (nvim_nvchad/)
```bash
# Format Lua code
stylua .

# Install markdown tools (run inside Neovim)
:MasonInstall markdownlint-cli2 prettier

# Deploy NvChad configuration
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim nvim_nvchad

# Setup Python provider (required for some plugins)
python3 -m venv ~/.venvs/neovim
~/.venvs/neovim/bin/pip install pynvim
```

### Profile System Commands (within Neovim)
```vim
:Profile cpp    " Switch to C/C++ profile
:Profile rust   " Switch to Rust profile
:Profile auto   " Auto-detect based on file type

<leader>pb      " Build current project
<leader>pt      " Test current project
<leader>pd      " Debug current project
```

### Code Quality Commands (within Neovim)
```vim
<leader>cf      " Format current buffer/selection
<leader>cl      " Run linter manually
<leader>cF      " Toggle format-on-save for buffer
<leader>cG      " Toggle format-on-save globally
```

## Code Quality

### Lua Formatting
Neovim Lua code should follow Stylua formatting standards. Configuration files:
- `nvim_nvchad/.stylua.toml`: Column width 120, 2-space indentation
- `nvim/` directory: Custom Stylua configuration

### Language Support
Primary languages in this repository:
- **Lua** (75+ files) - Neovim configuration and plugins
- **Shell scripts** - Bash/Zsh environment setup
- **Configuration files** - YAML, TOML, JSON for various tools

## Development Workflow

### Making Changes
1. Edit configuration files directly in their respective directories
2. Test changes by re-deploying with stow
3. Commit changes with descriptive messages following existing patterns

### Git Workflow
The repository uses conventional commit patterns and maintains separate concerns for each tool configuration. Recent commits show active development with clear, descriptive messages.

### Keyboard Setup
Custom keyboard layout scripts are located in `linux_shell/keyboard_setup/` for specialized input configurations.