#*******************************************************************************
#*   (c) 2020 Zondax GmbH
#*
#*  Licensed under the Apache License, Version 2.0 (the "License");
#*  you may not use this file except in compliance with the License.
#*  You may obtain a copy of the License at
#*
#*      http://www.apache.org/licenses/LICENSE-2.0
#*
#*  Unless required by applicable law or agreed to in writing, software
#*  distributed under the License is distributed on an "AS IS" BASIS,
#*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#*  See the License for the specific language governing permissions and
#*  limitations under the License.
#********************************************************************************

CONTAINER_NAME=zxtestrunner
DOCKER_IMAGE=zondax/zxtestrunner

INTERACTIVE:=$(shell [ -t 0 ] && echo 1)
ifdef INTERACTIVE
INTERACTIVE_SETTING:="-i"
TTY_SETTING:="-t"
else
INTERACTIVE_SETTING:=""
TTY_SETTING:=""
endif

ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

define run_docker
    docker run $(TTY_SETTING) $(INTERACTIVE_SETTING) --rm \
    --name $(CONTAINER_NAME) --network="host" \
    -v $(shell pwd)/runner-storage:/home/runner/actions-runner \
    $(DOCKER_IMAGE) $(RUN_ARGS)
endef

define kill_docker
	docker kill $(CONTAINER_NAME)
endef

define login_docker
	docker exec -ti $(CONTAINER_NAME) /bin/bash
endef

all: run
.PHONY: all

build:
	docker build -t $(DOCKER_IMAGE) .
.PHONY: build

rebuild:
	docker build --no-cache -t $(DOCKER_IMAGE) .
.PHONY: rebuild

clean:
	docker rmi $(DOCKER_IMAGE)
.PHONY: clean

run: build
	chmod 777 runner-storage
	$(call run_docker)
.PHONY: run

login:
	$(call login_docker)
.PHONY: login

stop:
	$(call kill_docker)
.PHONY: stop
