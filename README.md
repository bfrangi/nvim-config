# Personal `nvim` configuration

This repository contains my personal configuration for `nvim`, as well as the steps to install and use `nvim` with this configuration in a debian based system.

## Installing `nvim`

From the official [`nvim` installation guide](https://github.com/neovim/neovim/wiki/Installing-Neovim):

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz &&
tar xzvf nvim-linux64.tar.gz &&
./nvim-linux64/bin/nvim
````

## Add the config

Clone the repo and copy the file `init.lua` into `~/.config/nvim/init.lua`. For that, open a terminal window wherever you want to clone the repo and run the following commands:

```bash
git clone https://github.com/bfrangi/nvim-config.git
mkdir -p ~/.config/nvim &&
touch ~/.config/nvim/init.lua &&
cp ./nvim-config/init.lua ~/.config/nvim/init.lua
```

## Installing Dependencies

Run the following commands to install dependencies:

```bash
pip install mypy flake8 isort pycln autoflake8 autoimport autopep8
```

Make sure you have installed `nodejs` and `npm`. If not, run:

```bash
sudo apt install curl &&
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - &&
sudo apt install nodejs &&
node --version &&
npm --version
```

## Installing `nvim` Packages

After that is installed, run `nvim` to install all default packages & theme. When done, inside `nvim`, open Mason package manager with `:Mason` and install the preferred packages. In this case, for Python development, install in this order:

- lua-language-server
- pyright
- marksman
- markdownlint
- stylua
- selene
