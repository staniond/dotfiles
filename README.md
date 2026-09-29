# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a **stow package** whose contents mirror the layout
of `$HOME`. Stowing a package creates the symlinks for it; unstowing removes
them again.

```
~/.dotfiles/
├── bash/.bash_aliases                 ->  ~/.bash_aliases
├── git/.gitconfig                     ->  ~/.gitconfig
├── nvim/.config/nvim/init.vim         ->  ~/.config/nvim/init.vim
├── starship/.config/starship.toml     ->  ~/.config/starship.toml
├── tmux/.tmux.conf                    ->  ~/.tmux.conf
│    └─ .tmuxline                      ->  ~/.tmuxline
├── vim/.vimrc                         ->  ~/.vimrc
└── zed/.config/zed/settings.json      ->  ~/.config/zed/settings.json
     └─ .config/zed/keymap.json        ->  ~/.config/zed/keymap.json
```

## Install

Clone the repo and run the install script. It installs the prerequisites
(stow, starship, vim-plug, jedi), then stows every package:

```sh
git clone https://github.com/<you>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

Everything it does is idempotent, so it is safe to re-run.

To install only some packages:

```sh
./install.sh vim tmux git
```

## Using stow directly

If the prerequisites are already installed, stow is all you need. From inside
the repo, create **all** symlinks with:

```sh
stow --target="$HOME" --no-folding bash git nvim starship tmux vim zed
```

A single package:

```sh
stow --target="$HOME" --no-folding tmux
```

Remove the symlinks for a package (`-D`):

```sh
stow --target="$HOME" -D zed
```

Re-create them after adding or renaming files (`-R`, restow):

```sh
stow --target="$HOME" --no-folding -R bash git nvim starship tmux vim zed
```

Preview without touching anything (`-n` plus `-v`):

```sh
stow -nv --target="$HOME" --no-folding bash git nvim starship tmux vim zed
```

Notes:

- `--target="$HOME"` is optional when the repo lives at `~/.dotfiles`, since
  stow defaults to the parent of the stow directory. It is spelled out here so
  the commands work from a clone in any location.
- `--no-folding` makes stow link each *file* individually rather than
  symlinking a whole directory when the target directory does not exist yet.
  Without it a fresh machine would get `~/.config/zed -> ~/.dotfiles/zed/.config/zed`,
  and anything Zed later wrote into that directory would land inside this repo.
- Stow refuses to overwrite a file it did not create. `install.sh` handles this
  by removing stale symlinks that point into the repo and moving any real file
  to `<file>.backup` before stowing.

## bash

`bash/.bash_aliases` is stowed to `~/.bash_aliases`, which the stock
Debian/Ubuntu `~/.bashrc` already sources:

```sh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```

So on Debian/Ubuntu no change to `~/.bashrc` is needed at all. On other
systems `install.sh` appends the equivalent hook once, marked with
`# DOTFILES_TAG`.

## Adding a new dotfile

Create the package directory mirroring its path under `$HOME`, move the file
in, and restow:

```sh
mkdir -p ~/.dotfiles/foo/.config/foo
mv ~/.config/foo/config.toml ~/.dotfiles/foo/.config/foo/config.toml
cd ~/.dotfiles && stow --target="$HOME" --no-folding foo
```

Add the package name to `ALL_PACKAGES` in `install.sh` so it is picked up on
the next fresh install.
