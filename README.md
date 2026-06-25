# dotfiles

Personal shell, prompt, and editor configuration — symlinked into `$HOME` with a single setup script.

## Contents

| Path | Symlinked to | What it is |
|------|--------------|------------|
| `zsh/.zshrc` | `~/.zshrc` | Zsh config: Oh My Zsh, Powerlevel10k, plugins, PATH |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` | Powerlevel10k prompt theme |
| `zsh/.zsh/` | `~/.zsh/` | Custom functions & aliases (`functions/index.zsh`) |
| `nvim/` | `~/.config/nvim/` | Neovim config (`init.lua`) |

## Install

```sh
git clone git@github.com:Amitrochates/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` creates the symlinks listed above, backing up nothing — it removes any existing target first, so back up your own configs beforehand if needed.

## Dependencies

The Zsh config expects these to be installed:

- [Oh My Zsh](https://ohmyz.sh/) at `~/.oh-my-zsh`
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- Plugins: [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions), [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting), `fzf`, `git`
- Optional, picked up if present: [nvm](https://github.com/nvm-sh/nvm), [bun](https://bun.sh/), Go, [opencode](https://github.com/opencode-ai/opencode)

## Notes

**Custom shell functions** (`zsh/.zsh/functions/index.zsh`):
- `git diff` / `docker kill` — drop into an `fzf` picker when run with no arguments, otherwise behave normally.

**Fast startup.** nvm is lazy-loaded (initialized on first use of `node`/`npm`/`npx`/`nvm`), and the Oh My Zsh auto-update check and per-startup compinit audit are disabled. Interactive shells start in ~0.2s.

> ⚠️ Lazy-loading nvm disables per-directory `.nvmrc` auto-switching. Run `nvm use` manually in a project if you need a non-default Node version.
