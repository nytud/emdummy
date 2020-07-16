# Bash is needed for time
SHELL := /bin/bash -o pipefail
DIR := ${CURDIR}
red := $(shell tput setaf 1)
green := $(shell tput setaf 2)
sgr0 := $(shell tput sgr0)
# DEP_COMMAND := "command"
# DEP_FILE := "file"
MODULE := "emdummy"
TEST_INPUT := "input.xtsv"
TEST_OUTPUT := "output.xtsv"

all:
	@echo "See Makefile for possible targets!"

# extra:
# 	# Do extra stuff (e.g. compiling, downloading) before building the package

# install-dep-packages:
#    # Install packages in Aptfile
# 	sudo -E apt-get update
# 	sudo -E apt-get -yq --no-install-suggests --no-install-recommends $(travis_apt_get_options) install `cat Aptfile`

# check:
# 	# Check for file or command
# 	@test -f ${DEP_FILE} >/dev/null 2>&1 || \
# 		 { echo >&2 "File \`${DEP_FILE}\` could not be found!"; exit 1; }
# 	@command -v ${DEP_COMMAND} >/dev/null 2>&1 || { echo >&2 "Command \`${DEP_COMMAND}\`could not be found!"; exit 1; }

dist/*.whl dist/*.tar.gz: # check extra
	@echo "Building package..."
	python3 setup.py sdist bdist_wheel

build: dist/*.whl dist/*.tar.gz

install-user: build
	@echo "Installing package to user..."
	pip3 install dist/*.whl

test:
	@echo "Running tests..."
	time (cd /tmp && python3 -m ${MODULE} -i $(DIR)/tests/${TEST_INPUT} | \
	diff - $(DIR)/tests/${TEST_OUTPUT} 2>&1 | head -n100)

install-user-test: install-user test
	@echo "$(green)The test was completed successfully!$(sgr0)"

ci-test: install-user-test

uninstall:
	@echo "Uninstalling..."
	pip3 uninstall -y ${MODULE}

install-user-test-uninstall: install-user-test uninstall

clean:
	rm -rf dist/ build/ ${MODULE}.egg-info/

clean-build: clean build
