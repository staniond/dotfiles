#!/usr/bin/env bash
# Installs the prerequisites for these dotfiles, then symlinks every package
# into $HOME with GNU stow.
#
# Usage:
#   ./install.sh                # install everything and stow all packages
#   ./install.sh vim tmux git   # install everything and stow only these packages

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALL_PACKAGES=(bash git nvim starship tmux vim zed)

if [ "$#" -gt 0 ]; then
    PACKAGES=("$@")
else
    PACKAGES=("${ALL_PACKAGES[@]}")
fi

info() { printf '\n==> %s\n' "$1"; }

# --------------------------------------------------------------------------
# Prerequisites
# --------------------------------------------------------------------------

install_stow() {
    if command -v stow >/dev/null 2>&1; then
        echo "GNU stow already installed: $(stow --version | head -n1)"
        return
    fi
    echo 'installing GNU stow'
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y stow
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y stow
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm stow
    elif command -v brew >/dev/null 2>&1; then
        brew install stow
    else
        echo 'error: no known package manager, install GNU stow manually' >&2
        exit 1
    fi
}

install_starship() {
    if command -v starship >/dev/null 2>&1; then
        echo "starship already installed: $(starship --version | head -n1)"
        return
    fi
    echo 'installing starship'
    curl -sS https://starship.rs/install.sh | sh
}

install_vimplug() {
    local plug="$HOME/.local/share/nvim/site/autoload/plug.vim"
    if [ -f "$plug" ]; then
        echo 'vim-plug already installed'
        return
    fi
    echo 'installing vim-plug'
    curl -fLo "$plug" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_jedi() {
    if python3 -c 'import jedi' >/dev/null 2>&1; then
        echo 'jedi already installed'
        return
    fi
    echo 'installing jedi'
    # Newer distros ship an externally managed python, so fall back to --user.
    pip3 install jedi || pip3 install --user jedi
}

# --------------------------------------------------------------------------
# ~/.bashrc
#
# bash/.bash_aliases is stowed to ~/.bash_aliases, which the stock
# Debian/Ubuntu ~/.bashrc already sources. Elsewhere we add the hook
# ourselves, so nothing else in this repo needs to touch ~/.bashrc.
# --------------------------------------------------------------------------

setup_bashrc() {
    local rc="$HOME/.bashrc"

    if [ ! -f "$rc" ]; then
        echo 'no ~/.bashrc found, skipping'
        return
    fi

    # Drop the hook left behind by the pre-stow version of this script.
    if grep -q 'DOTFILES_TAG' "$rc" && grep -q 'custom_bashrc' "$rc"; then
        echo "removing legacy custom_bashrc hook (backup: $rc.backup)"
        cp "$rc" "$rc.backup"
        sed -i '/# DOTFILES_TAG/{N;/custom_bashrc/d}' "$rc"
    fi

    if grep -q 'bash_aliases' "$rc"; then
        echo '~/.bashrc already sources ~/.bash_aliases, nothing to add'
    else
        echo 'adding a ~/.bash_aliases hook to ~/.bashrc'
        printf '\n# DOTFILES_TAG\n[ -f ~/.bash_aliases ] && . ~/.bash_aliases\n' >> "$rc"
    fi
}

# --------------------------------------------------------------------------
# stow
# --------------------------------------------------------------------------

# Stow refuses to overwrite anything it did not create, so clear the way first:
# drop symlinks that already point into this repo, and back up real files.
clear_conflicts() {
    local pkg="$1" src rel target link

    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        echo "error: no such package: $pkg" >&2
        exit 1
    fi

    while IFS= read -r -d '' src; do
        rel="${src#"$DOTFILES_DIR/$pkg/"}"
        target="$HOME/$rel"

        if [ -L "$target" ]; then
            link="$(readlink -f "$target")"
            case "$link" in
                "$DOTFILES_DIR"/*)
                    echo "  unlinking $target"
                    rm "$target"
                    ;;
            esac
        elif [ -e "$target" ]; then
            echo "  backing up $target -> $target.backup"
            mv "$target" "$target.backup"
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
}

run_stow() {
    local pkg
    for pkg in "${PACKAGES[@]}"; do
        clear_conflicts "$pkg"
    done
    stow --dir "$DOTFILES_DIR" --target "$HOME" --no-folding --restow --verbose "${PACKAGES[@]}"
}

# --------------------------------------------------------------------------

info 'Installing GNU stow';  install_stow
info 'Installing starship';  install_starship
info 'Installing vim-plug';  install_vimplug
info 'Installing jedi';      install_jedi
info 'Configuring ~/.bashrc'; setup_bashrc
info "Stowing: ${PACKAGES[*]}"; run_stow

info 'Done. Restart your shell to pick up ~/.bash_aliases.'
