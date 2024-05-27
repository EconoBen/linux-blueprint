# Use the official Ubuntu base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
	build-essential \
	zlib1g-dev \
	libncurses5-dev \
	libgdbm-dev \
	libnss3-dev  \
	libssl-dev \
	libreadline-dev \
	libffi-dev \
	libsqlite3-dev \
	wget \
	libbz2-dev\
	liblzma-dev \
	curl \
	vim \
	zsh \
	git \
	unzip \
	fontconfig \
	bat # A cat clone with wings https://github.com/sharkdp/bat


# Install UV Package Manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Pyenv
RUN curl https://pyenv.run | bash

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
	echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
	echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Install Python 3.12.1
RUN /bin/zsh -c 'source $HOME/.zshrc && \
	pyenv install 3.12.1 && \
	pyenv global 3.12.1'

# Download and unzip Fira Code Nerd Font for Starship
RUN curl -fLo FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip && \
	unzip FiraCode.zip -d /usr/local/share/fonts && \
	rm FiraCode.zip


# Install Starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes && \
	echo 'eval "$(starship init zsh)"' >> ~/.zshrc && \
	mkdir -p ~/.config

# Ensure the starship.toml file is in the same directory as the Dockerfile or adjust the path accordingly
COPY starship.toml /root/.config/starship.toml

# Update font cache (optional, useful if your applications use fontconfig)
RUN fc-cache -fv

#### Setting Up batcat as bat ####
# Create the directory for local binaries
RUN mkdir -p /root/.local/bin

# Create a symbolic link for batcat as bat
RUN ln -s /usr/bin/batcat /root/.local/bin/bat

# Add the local bin directory to PATH in .zshrc for runtime usage
RUN echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.zshrc

WORKDIR /root

# Set the default shell to zsh
SHELL ["/bin/zsh", "-c"]

# Set the default command to run when starting the container
CMD ["zsh", "-c", "source $HOME/.cargo/env && zsh"]
