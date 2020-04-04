all: tag

PWD = $(shell pwd)

VERSION = 1.0.0
PROJECT_NAME = rpi-quake3-server

DOCKERFILE = ./Dockerfile
TAG = nightapp/$(PROJECT_NAME)

clean:
	-rm -f ./qemu-arm-static

qemu-arm-static:
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	curl -OL https://github.com/multiarch/qemu-user-static/releases/download/v4.1.0-1/qemu-arm-static
	chmod +x qemu-arm-static

build: qemu-arm-static ./Dockerfile
	docker build -f ./Dockerfile -t $(TAG) .

tag: build
	docker tag $(TAG) $(TAG):$(VERSION)

push-version: tag
	docker push $(TAG):$(VERSION)

push-latest: tag
	docker push $(TAG):latest

push: push-version push-latest
