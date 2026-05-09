<h2 align="center">w-wezterm-config</h2>

> This project is adapted from [Kevin Silvester's wezterm-config](https://github.com/KevinSilvester/wezterm-config).  
> Thanks to the original author for the structure and ideas that this config builds on.

<p align="center">
  <a href="https://github.com/devilkidd/w-wezterm-config/stargazers">
    <img alt="Stargazers" src="https://img.shields.io/github/stars/devilkidd/w-wezterm-config?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41">
  </a>
  <a href="https://github.com/devilkidd/w-wezterm-config/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/devilkidd/w-wezterm-config?style=for-the-badge&logo=gitbook&color=B5E8E0&logoColor=D9E0EE&labelColor=302D41">
  </a>
  <a href="https://github.com/devilkidd/w-wezterm-config/actions/workflows/lint.yml">
    <img alt="Build" src="https://img.shields.io/github/actions/workflow/status/devilkidd/w-wezterm-config/lint.yml?&style=for-the-badge&logo=githubactions&label=CI&color=A6E3A1&logoColor=D9E0EE&labelColor=302D41">
  </a>
</p>

## What This Config Does

This repository contains the exact WezTerm configuration currently used in this workspace.

It provides:
- platform-specific shell launchers
- Windows-only WSL domain shortcuts
- JetBrains Mono Nerd Font with fallback fonts
- leader-based resize and background key tables
- tab, pane, window, and URL helper bindings
- status bar widgets for left status, right status, and tab titles

## Platform Behavior

### Shells

- Windows: `pwsh -NoLogo`
- macOS: `zsh -l`
- Linux: `zsh -l`

### Launch Menu

- Windows: PowerShell Core, PowerShell Desktop, Command Prompt, Nushell, Msys2, Git Bash
- macOS: Zsh, Bash
- Linux: Zsh, Bash

### Domains

- Windows only:
  - `ssh:wsl`
  - `wsl:ubuntu-fish`
  - `wsl:ubuntu-bash`
- macOS/Linux: no custom domains

### Fonts

- Primary font: `JetBrainsMono Nerd Font`
- Fallback fonts:
  - `Maple Mono NF`
  - `Sarasa Mono SC`
  - `Noto Sans Mono CJK SC`
  - `Symbols Nerd Font Mono`

## Agent Quick Start

1. Read this README first.
2. Load `wezterm.lua`, then inspect `config/*`, `events/*`, and `utils/*`.
3. Apply platform-specific logic only in `config/launch.lua`, `config/domains.lua`, `config/fonts.lua`, and `config/bindings.lua`.
4. Keep the shortcut tables below synchronized with `config/bindings.lua`.
5. Verify by launching WezTerm once after copying the files.

## Install

### Requirements

- WezTerm
- JetBrainsMono Nerd Font or a compatible Nerd Font

### Clone

```sh
git clone https://github.com/devilkidd/w-wezterm-config.git ~/.config/wezterm
```

### Optional Platform Notes

- Windows WSL user and distro can be overridden with:
  - `WEZTERM_WSL_USER`
  - `WEZTERM_WSL_DISTRO`
- Windows Git Bash path is derived from `wezterm.home_dir`

## Key Bindings

### Modifier Mapping

- macOS:
  - `SUPER` = `Cmd`
  - `SUPER_REV` = `Cmd+Ctrl`
- Windows/Linux:
  - `SUPER` = `Alt`
  - `SUPER_REV` = `Alt+Ctrl`
- Leader:
  - `LEADER` = `SUPER_REV + Space`

### General

| Keys | Action |
| --- | --- |
| `F1` | `ActivateCopyMode` |
| `F2` | `ActivateCommandPalette` |
| `F3` | `ShowLauncher` |
| `F4` | `ShowLauncherArgs` for tabs |
| `F5` | `ShowLauncherArgs` for workspaces |
| `F11` | `ToggleFullScreen` |
| `F12` | `ShowDebugOverlay` |
| `SUPER+f` | Search text |
| `SUPER_REV+u` | Open URL under cursor selection |

### Copy and Paste

| Keys | Action |
| --- | --- |
| `Ctrl+Shift+c` | Copy to clipboard |
| `Ctrl+Shift+v` | Paste from clipboard |

### Cursor Movement

| Keys | Action |
| --- | --- |
| `SUPER+LeftArrow` | Move cursor to line start |
| `SUPER+RightArrow` | Move cursor to line end |
| `SUPER+Backspace` | Clear line |

### Tabs

| Keys | Action |
| --- | --- |
| `SUPER+t` | Spawn tab in default domain |
| `SUPER_REV+t` | Spawn WSL tab |
| `SUPER_REV+w` | Close current tab |
| `SUPER+[` | Next tab |
| `SUPER+]` | Previous tab |
| `SUPER_REV+[` | Move tab left |
| `SUPER_REV+]` | Move tab right |
| `SUPER+9` | Toggle tab bar |
| `SUPER+0` | Rename current tab |
| `SUPER_REV+0` | Undo tab rename |

### Windows

| Keys | Action |
| --- | --- |
| `SUPER+n` | Spawn window |
| `SUPER_REV+Enter` | Maximize window |

### Panes

| Keys | Action |
| --- | --- |
| `SUPER+\` | Split horizontally |
| `SUPER_REV+\` | Split vertically |
| `SUPER+Enter` | Toggle pane zoom |
| `SUPER+w` | Close current pane |
| `SUPER_REV+k/j/h/l` | Move between panes |
| `SUPER_REV+p` | Swap with selected pane |
| `SUPER+u/d` | Scroll pane content |
| `PageUp/PageDown` | Scroll page |

### Leader Tables

| Keys | Action |
| --- | --- |
| `LEADER+f` | `resize_font` |
| `LEADER+p` | `resize_pane` |
| `LEADER+w` | `resize_window` |
| `LEADER+b` | `background` |
| `LEADER+F1` | Show key assignments |

#### `resize_font`

| Keys | Action |
| --- | --- |
| `k` | Increase font size |
| `j` | Decrease font size |
| `r` | Reset font size |
| `q` / `Esc` | Exit |

#### `resize_pane`

| Keys | Action |
| --- | --- |
| `k` | Resize up |
| `j` | Resize down |
| `h` | Resize left |
| `l` | Resize right |
| `q` / `Esc` | Exit |

#### `resize_window`

| Keys | Action |
| --- | --- |
| `-` | Shrink window |
| `=` | Grow window |
| `q` / `Esc` | Exit |

#### `background`

| Keys | Action |
| --- | --- |
| `/` | Random background |
| `,` | Previous background |
| `.` | Next background |
| `s` | Select background |
| `b` | Toggle background focus |
| `q` / `Esc` | Exit |

## Notes

- `window_close_confirmation` is enabled for window-level closes.
- Tab and pane closes are direct and do not show confirmation prompts.
- Background selection uses the images in `backdrops/`.
