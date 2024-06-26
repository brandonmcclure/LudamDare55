.PHONY: all clean test lint
all: build

getcommitid: 
	$(eval COMMITID = $(shell git log -1 --pretty=format:"%H"))
getbranchname:
	$(eval BRANCH_NAME = $(shell echo "$$(git branch --show-current)" | sed 's/\//./g'))

REGISTRY_NAME := forgejo.themongoose.xyz/
REPOSITORY_NAME := brandon/
IMAGE_NAME := ludamdare55
TAG := :latest

build:
	docker run -v "$${PWD}/GameCode:/app" ghcr.io/brandonmcclure/godot-docker/godot:4.2.1 --export-release "Web" --headless ./build/web/index.html
build_docker: getcommitid getbranchname
	docker build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME) -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME):$(BRANCH_NAME)_$(COMMITID) .


run_docker: build_docker clean
	docker run -d -p 127.0.0.1:5935:80 --name ludamdare55 $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG)
clean:
	-docker stop ludamdare55
	-docker rm ludamdare55	
py_serve:
	python serve.py --root ./GameCode/bin/.
build:
	cd GameCode; godot --headless --export-release "Linux/X11"
	cd GameCode; godot --headless --export-release "Web"
	mv 'GameCode/bin/web/Game Code.html' GameCode/bin/web/index.html
# Act/github workflows
ACT_ARTIFACT_PATH := /workspace/.act 
act: act_MegaLinter act_validateLFS 
act_MegaLinter:
	act -j MegaLinter --artifact-server-path $(ACT_ARTIFACT_PATH)
act_validateLFS:
	act -j validateLFS --artifact-server-path $(ACT_ARTIFACT_PATH)
lint: lint_makefile
lint_makefile:
	docker run -v $${PWD}:/tmp/lint -e ENABLE_LINTERS=MAKEFILE_CHECKMAKE oxsecurity/megalinter-ci_light:v6.10.0
precommit_install:
	pre-commit install
precommit_checkall: precommit_install
	pre-commit run --all-files
