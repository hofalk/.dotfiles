## .dotfiles repo

### restore
```
git clone --bare https://github.com/h0lk/.dotfiles.git $HOME/.dotfiles
git submodule update --init --recursive

alias dots="/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
```
