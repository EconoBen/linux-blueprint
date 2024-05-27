#!/bin/bash
set -e

# Install UV Package Manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Pyenv
curl https://pyenv.run | bash

# Setup environment variables
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Python using pyenv
pyenv install 3.12.1
pyenv global 3.12.1


# Install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
