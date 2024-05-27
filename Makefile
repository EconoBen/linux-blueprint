.PHONY: up build run connect docker prune stop

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
