#!/bin/bash

# Step 0: Initial Setup - Install Docker, pipx, rich-cli, and container-structure-test
echo "Installing rich-cli and container-structure-test for enhanced logging and testing..."
brew install rich-cli
brew install container-structure-test

# Begin setup
rich "[bold magenta]Starting setup process...[/bold magenta]" --print

# Step 1: Build the Docker image
rich "[bold yellow]Building the Docker image...[/bold yellow]" --print
docker stop ubuntu_base_instance || true
docker rm ubuntu_base_instance || true

# Directly check the command execution
if ! docker build -t ubuntu_base .; then
    rich "[bold red]Docker build failed, exiting...[/bold red]" --print
    exit 1
else
    rich "[bold green]Docker build successful![/bold green]" --print
fi

# Step 2: Run the container
rich "[bold blue]Running the container...[/bold blue]" --print
docker run -d --name ubuntu_base_instance ubuntu_base

# Allow a few seconds for the container to fully start
sleep 5

# Step 3: Execute structure tests
rich "[bold yellow]Executing structure tests...[/bold yellow]" --print

# Directly check the command execution
if ! container-structure-test test --image ubuntu_base --config config.yaml; then
    rich "[bold red]Structure tests failed.[/bold red]" --print
    exit 1
else
    rich "[bold green]All structure tests passed.[/bold green]" --print
fi

# If tests pass, copy dotfiles from the container to the host
rich "[bold orange]Copying dotfiles from the container to the host...[/bold orange]" --print
docker cp ubuntu_base_instance:/root/.zshrc /Users/blabaschin/Documents/GitHub/linux-blueprint/.zshrc
docker cp ubuntu_base_instance:/root/.zshrc.pre-oh-my-zsh /Users/blabaschin/Documents/GitHub/linux-blueprint/.zshrc.pre-oh-my-zsh
docker cp ubuntu_base_instance:/root/.bashrc /Users/blabaschin/Documents/GitHub/linux-blueprint/.bashrc

# Step 5: Clean up - stop and remove the container
rich "[bold green]Cleaning up...[/bold green]" --print
docker stop ubuntu_base_instance
docker rm ubuntu_base_instance

rich "[bold green]Setup complete![/bold green]" --print
