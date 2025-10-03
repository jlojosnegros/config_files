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
- **nvim_nvchad/**: NvChad v2.5-based configuration (primary/active setup)

#### NvChad Configuration (nvim_nvchad/)

**Core Plugin Architecture:**
- Base: NvChad v2.5 with custom extensions
- Package Manager: Lazy.nvim (configured via lua/configs/lazy.lua)
- LSP: nvim-lspconfig with language-specific servers (lua/configs/lspconfig.lua)
- Formatting: conform.nvim (lua/configs/conform.lua)
- Linting: nvim-lint (lua/plugins/format-lint-dap.lua)
- Debugging: nvim-dap with UI extensions (lua/configs/dap.lua)
- Theme: Catppuccin with custom highlight overrides (lua/chadrc.lua)

**Profile System Architecture:**
The profile system (lua/profiles/) provides language-specific development workflows:

- **Manager** (profiles/manager.lua):
  - Auto-detects language from filetype on BufEnter
  - Routes build/test/debug commands to active profile
  - Provides `:Profile [cpp|rust|auto]` command
  - Stores current profile in `vim.g.active_code_profile`

- **C/C++ Profile** (profiles/cpp.lua):
  - Bazel build system integration
  - Commands run via nvterm or fallback terminal
  - Build: `bazel build //...`
  - Test: `bazel test //...`
  - Debug: Launches nvim-dap for C/C++

- **Rust Profile** (profiles/rust.lua):
  - Cargo build system integration
  - Similar terminal integration pattern

**Key Bindings Organization:**
- `<leader>s*`: Telescope search (files, grep, symbols, diagnostics)
- `<leader>S*`: Advanced in-buffer search with persistent results window
- `<leader>g*`: Git operations (gitsigns + Telescope)
- `<leader>c*`: Code operations (LSP, format, lint)
- `<leader>d*`: Debug operations (nvim-dap)
- `<leader>p*`: Profile management (build/test/debug via active profile)
- `<leader>b*`: Buffer navigation
- `<leader>j*`: Jump operations with jumplist position memory
- `<leader>w*`: Window/split management
- `<leader>t*`: Tab management
- `<leader>D*`: Diff mode operations
- `<leader>lg`: LazyGit in floating window from git root

**Advanced Features:**
- **Smart Search**: Custom search implementation (mappings.lua) with persistent results window, smartcase, and live navigation
- **Diff Mode**: Full diff workflow with file comparison, git history comparison, and split management
- **Split Visibility**: Enhanced window separator styles with toggle options
- **Format on Save**: Per-buffer and global toggles via `vim.b.disable_autoformat` and `vim.g.disable_autoformat`

**Dependencies:**
- Python venv at `~/.venvs/neovim` with pynvim for full plugin functionality
- Mason for LSP server/tool management
- External tools: stylua (Lua formatting), lazygit, bazel/cargo (per profile)

### Tmux Configuration
Tmux is configured with Catppuccin Mocha theme and TPM (Tmux Plugin Manager):

**Key Configuration:**
- Prefix key: `Ctrl-t` (not default `Ctrl-b`)
- Config location: `~/.config/tmux/tmux.conf` (deployed via stow)
- Plugin manager: TPM at `~/.tmux/plugins/tpm`
- Theme: Catppuccin v2.1.3 (Mocha flavor) with custom pane/window styling
- Clipboard integration: Uses `xsel` for copy operations

**Core Keybindings:**
- `Ctrl-t Ctrl-t`: Switch to last window
- `Ctrl-t h/j/k/l`: Navigate panes (vim-style)
- `Ctrl-t H/J/K/L`: Resize panes
- `Ctrl-t |`: Split horizontal (keeps current path)
- `Ctrl-t -`: Split vertical (keeps current path)
- `Ctrl-t c`: New window (keeps current path)
- `Ctrl-t b`: Break pane to new window
- `Ctrl-t a`: Join pane from another window
- `Ctrl-t S`: Send pane to window number
- `Ctrl-t @`: Rename pane title
- `Ctrl-t g`: Move window from another session
- `Ctrl-t G`: Link window from another session
- `Ctrl-t N`: Create new session
- `Ctrl-t r`: Reload config

**Plugin Setup:**
After initial stow deployment, install TPM and plugins:
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Inside tmux, press: Ctrl-t I (capital i) to install plugins
```

**Active Plugins:**
- catppuccin/tmux - Theme with custom status modules
- tmux-battery - Battery status indicator
- tmux-cpu - CPU usage indicator
- tmux-yank - Clipboard integration

**Status Bar Modules:**
Status bar (top position) shows: Application | CPU | Session | Uptime | Battery

**Copy Mode:**
- Vim keybindings enabled (`mode-keys vi`)
- Mouse selection auto-copies to clipboard via `xsel`
- Enter in copy mode: Copy and exit
- Mouse drag: Select and auto-copy on release

### Shell Environment
Zsh configuration includes:
- Zinit plugin manager for performance
- Powerlevel10k prompt theme
- Zoxide for intelligent directory navigation
- Go development environment (version 1.22.1 via gimme)

## Common Development Commands

### Stow Deployment
```bash
# Deploy configurations
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim nvim_nvchad
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux tmux
stow -v -d /home/jojosneg/source/mine/config_files/linux_shell -t /home/jojosneg zsh
stow -v -d /home/jojosneg/source/mine/config_files -t /home/jojosneg git

# Remove configurations
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim -D nvim_nvchad
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux -D tmux

# Test deployment (dry-run)
stow -n -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/nvim nvim_nvchad
```

### Tmux Setup
```bash
# Deploy configuration
stow -v -d /home/jojosneg/source/mine/config_files/ -t /home/jojosneg/.config/tmux tmux

# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
tmux
# Then press: Ctrl-t I (capital I) to install plugins

# Reload tmux config (from within tmux)
# Press: Ctrl-t r
```

### NvChad Configuration
```bash
# Format Lua code (from repository root)
cd nvim_nvchad && stylua .

# Setup Python provider (required for some plugins)
python3 -m venv ~/.venvs/neovim
~/.venvs/neovim/bin/pip install pynvim
```

### Neovim Commands (nvim_nvchad)

**Profile System:**
```vim
:Profile cpp    " Switch to C/C++ profile (Bazel build system)
:Profile rust   " Switch to Rust profile (Cargo)
:Profile auto   " Auto-detect based on file type

<leader>pb      " Build current project (uses active profile)
<leader>pt      " Test current project (uses active profile)
<leader>pd      " Debug current project (launches nvim-dap)
```

**Code Quality:**
```vim
<leader>cf      " Format current buffer/selection (conform.nvim)
<leader>cl      " Run linter manually (nvim-lint)
<leader>cF      " Toggle format-on-save for buffer
<leader>cG      " Toggle format-on-save globally
<leader>ca      " LSP code action
<leader>cr      " LSP rename symbol
```

**Git Operations:**
```vim
<leader>gs      " Git status (Telescope)
<leader>gc      " Git commits (Telescope)
<leader>gb      " Git branches (Telescope)
<leader>gS      " Stage hunk (gitsigns)
<leader>gR      " Reset hunk
<leader>gP      " Preview hunk
<leader>gB      " Blame line
<leader>gd      " Diff against HEAD
<leader>lg      " LazyGit in floating window
```

**Search & Navigation:**
```vim
<leader>sf      " Find files (Telescope)
<leader>sg      " Live grep in project
<leader>sw      " Search word under cursor
<leader>sr      " LSP references
<leader>ss      " LSP document symbols

<leader>Ss      " Advanced search in buffer (persistent window)
<leader>Sw      " Search word under cursor (persistent)
<leader>Sr      " Regex search in buffer
<leader>Sn/Sp   " Next/previous search result
```

**Window & Buffer Management:**
```vim
<leader>wv/wh   " Split vertical/horizontal
<leader>ww      " Cycle windows
<leader>w=      " Equalize window sizes
<leader>wc      " Close current window
<leader>bn/bp   " Next/previous buffer
<leader>bd      " Delete current buffer
<leader>bo      " Close other buffers
```

**Diff Mode:**
```vim
<leader>Df      " Diff current buffer with selected file
<leader>DD      " Diff between two selected files
<leader>Dg      " Diff current file with git commit
<leader>Dn/DP   " Next/previous difference
<leader>Do/Dp   " Obtain/put diff change
<leader>Dq      " Exit diff mode
```

**Tabs:**
```vim
<leader>tn      " New tab
<leader>tc      " Close tab
<leader>tj/tk   " Next/previous tab
<leader>t1-9    " Go to tab number
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

## Key Implementation Patterns

### Neovim Configuration Structure (nvim_nvchad/)
When modifying the NvChad configuration, follow these patterns:

**Plugin Management:**
- New plugins: Add to `lua/plugins/init.lua` or create dedicated files in `lua/plugins/`
- Plugin configurations: Place in `lua/configs/[plugin-name].lua`
- Plugin specs use lazy.nvim format with `opts` for simple config or `config = function()` for complex setup

**Keybindings:**
- All custom keymaps centralized in `lua/mappings.lua`
- Use which-key groups to organize related commands under common prefixes
- Pattern: Create helper functions for complex operations, then map to keybinding
- Lazy-load heavy operations with `pcall(require, ...)` for graceful fallback

**Profile System Extension:**
To add a new language profile:
1. Create `lua/profiles/[language].lua` with `build()`, `test()`, `debug()` functions
2. Add profile to `profiles` table in `lua/profiles/manager.lua`
3. Update `detect()` function to recognize new filetypes
4. Update `:Profile` command completion list

**Custom Features:**
- State management: Use module-local tables (e.g., `search_state`, `diff_state` in mappings.lua)
- Cleanup functions: Always provide functions to reset/cleanup stateful features
- Window/buffer operations: Check validity with `vim.api.nvim_*_is_valid()` before accessing
- User feedback: Use `vim.notify()` for status messages with appropriate log levels

### Git Configuration Patterns
- Context-specific identities: Use `[includeIf "gitdir:path/"]` for automatic profile switching
- Keep profile files separate: `.gitconfig_redhat`, `.gitconfig_mine_github`, etc.
- Main `.gitconfig` contains only aliases and tool configurations

### Stow Patterns
When adding new configuration packages:
- Maintain proper directory structure relative to deployment target
- Use `-n -v` flags to preview before actual deployment
- Document stow commands in README.md for future reference
- Test removal with `-D` flag before committing new packages

## File Locations

**Current Working Directory:** `/home/jojosneg/source/mine/config_files/nvim_nvchad`

**Key Configuration Paths:**
- Neovim (NvChad): `~/.config/nvim` (stow from `nvim_nvchad/`)
- Tmux: `~/.config/tmux` (stow from `tmux/`)
- Git: `~/.gitconfig` (stow from `git/`)
- Zsh: `~/.zshrc` (stow from `linux_shell/zsh/`)
- LazyGit: `~/.config/lazygit` (stow from `lazygit/`)
- Python Provider: `~/.venvs/neovim/`