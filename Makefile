.PHONY: up build run connect docker \
		prune stop shellcheck yamllint \
		freeze check source

build: # Build the Docker Image:
	docker build -t ubuntu_base .

run:
	docker run -it --name ubuntu_base_instance ubuntu_base

stop:
	docker stop ubuntu_base_instance || true
	docker rm ubuntu_base_instance || true

up: # run build and test commands
	./build.mac.sh

connect: # connect to the container
	docker exec -it ubuntu_base_instance bash

docker: build run prune

prune: # remove all stopped containers, all dangling images, and all unused networks
	docker system prune -a

source:
	@rich --print "[bold blue]Sourcing the virtual environment...[/bold blue]"
	@echo "-----------------------------------"
	@source .venv/bin/activate
	@echo "-----------------------------------"

shellcheck:
	@rich --print "[bold blue]Linting shell scripts with shellcheck...[/bold blue]"
	@echo "-----------------------------------"
	uv pip install shellcheck-py
	@find . -name "*.sh" -not -path "./.venv/*" | xargs shellcheck

yamllint:
	@rich --print "[bold blue]Linting YAML files with yamllint...[/bold blue]"
	@echo "-----------------------------------"
	uv pip install yamllint
	@yamllint .

freeze:
	@rich --print "[bold blue]Freezing requirements...[/bold blue]"
	@echo "-----------------------------------"
	@uv pip freeze > requirements.txt
	@echo "-----------------------------------"

check:
	@rich --print "[bold blue]Running all checks...[/bold blue]"
	@echo "-----------------------------------"
	@$(MAKE) ruff
	@$(MAKE) shellcheck
	@$(MAKE) yamllint
	@echo "-----------------------------------"
	@rich --print "[bold green]All checks passed![/bold green]"
