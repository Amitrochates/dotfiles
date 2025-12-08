#!/usr/bin/env bash

# Directory containing your managed dotfiles
DOTFILES="$HOME/dotfiles"

# Symlink function
link() {
    src="$DOTFILES/$1"
    dest="$HOME/$2"

    # Make sure the destination directory exists
    mkdir -p "$(dirname "$dest")"

    # Remove old file if it exists
    [ -e "$dest" ] && rm -rf "$dest"

    echo "Linking $src → $dest"
    ln -s "$src" "$dest"
}

# Add each config you want symlinked here:

link "zsh/.zshrc" ".zshrc"
link "zsh/.zsh" ".zsh"
link "zsh/.p10k.zsh" ".p10k.zsh"
