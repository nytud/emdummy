.DEFAULT_GOAL = all
# Bash is needed for time, compgen, [[ and other builtin commands

SHELL := /bin/bash -o pipefail

RED := $(shell tput setaf 1)
GREEN := $(shell tput setaf 2)
BOLD := $(shell tput rev)
NONE := $(shell tput sgr0)

PYTHON := python3

# Module specific parameters
MODULE := emdummy
MODULE_PARAMS :=

# These targets do not show as possible target with bash completion
	# Do extra stuff (e.g. compiling, downloading) before building the package
__extra-deps:
	@exit 0
.PHONY: __extra-deps

	# e.g. @rm -rf stuff
__clean-extra-deps:
	@exit 0
.PHONY: __clean-extra-deps

# From here only generic parts

# Parse version string and create new version. Originally from: https://github.com/mittelholcz/contextfun
# Variable is empty in Travis-CI if not git tag present
TRAVIS_TAG ?= ""
OLDVER := $$(grep -P -o '(?<=version = ")[^"]+' pyproject.toml)

MAJOR := $$(echo $(OLDVER) | sed -r s"/([0-9]+)\.([0-9]+)\.([0-9]+)/\1/")
MINOR := $$(echo $(OLDVER) | sed -r s"/([0-9]+)\.([0-9]+)\.([0-9]+)/\2/")
PATCH := $$(echo $(OLDVER) | sed -r s"/([0-9]+)\.([0-9]+)\.([0-9]+)/\3/")

NEWMAJORVER="$$(( $(MAJOR)+1 )).0.0"
NEWMINORVER="$(MAJOR).$$(( $(MINOR)+1 )).0"
NEWPATCHVER="$(MAJOR).$(MINOR).$$(( $(PATCH)+1 ))"

all: clean venv test
	@echo "all: clean, venv, test"
	@echo
	@echo "$(GREEN)Package $(MODULE) is successfully installed and all tests are OK! :)$(NONE)"
	@echo
.PHONY: all

install-dep-packages:
	@echo "$(BOLD)Installing needed packages from Aptfile...$(NONE)"
	@# Aptfile can be omited if empty
	@[[ ! -s "$(CURDIR)/Aptfile" ]] || \
	  ((command -v apt >/dev/null 2>&1 || (echo >&2 "$(RED)Command 'apt' could not be found!$(NOCOLOR)"; exit 1)) && \
	   ([[ $$(dpkg -l | grep -wcf $(CURDIR)/Aptfile) -ne $$(cat $(CURDIR)/Aptfile | wc -l) ]] || \
	    (sudo -E apt-get update && \
	     sudo -E apt-get -yq --no-install-suggests --no-install-recommends $(travis_apt_get_options) \
	      install `cat $(CURDIR)/Aptfile`)))
	@echo "$(GREEN)2/5 Needed packages are successfully installed!$(NONE)"
.PHONY: install-dep-packages

venv:
	@echo "$(BOLD)Creating virtualenv in $(VENVDIR)...$(NONE)"
	@poetry install
	@echo "$(GREEN)1/5 Virtualenv is successfully created!$(NONE)"
	@echo
.PHONY: venv

build: install-dep-packages venv __extra-deps
	@echo "$(BOLD)Building package...$(NONE)"
	@poetry build
	@echo "$(GREEN)3/5 Package $(MODULE) is successfully built!$(NONE)"
	@echo
.PHONY: build

# Install the actual wheel package to test it in later steps
install: build
	@echo "$(BOLD)Installing package to user...$(NONE)"
	 @poetry run pip install --upgrade dist/*.whl
	@echo "$(GREEN)4/5 Package $(MODULE) is successfully installed!$(NONE)"
	@echo
.PHONY: install

test:
	@echo "$(BOLD)Running tests...$(NONE)"
	poetry run pytest --verbose tests/
	echo "$(GREEN)5/5 The test was completed successfully!$(NONE)"
.PHONY: test

clean: __clean-extra-deps
	rm -rf dist/ build/ $(MODULE).egg-info/ $$(poetry env info -p)
.PHONY: clean

# Do actual release with new version. Originally from: https://github.com/mittelholcz/contextfun
# poetry version will modify pyproject.toml only. The other steps must be done manually.
release-major:
	@poetry version major
	@make -s __release NEWVER=$(NEWMAJORVER)
.PHONY: release-major

release-minor:
	@poetry version minor
	@make -s __release NEWVER=$(NEWMINORVER)
.PHONY: release-minor

release-patch:
	@poetry version patch
	@make -s __release NEWVER=$(NEWPATCHVER)
.PHONY: release-patch

__release:
	@[[ ! -z "$(NEWVER)" ]] || \
		(echo -e "$(RED)Do not call this target!\nUse 'release-major', 'release-minor' or 'release-patch'!$(NONE)"; \
		 exit 1)
	@[[ -z $$(git status --porcelain) ]] || (echo "$(RED)Working dir is dirty!$(NONE)"; exit 1)
	@echo "NEW VERSION: $(NEWVER)"
	# Clean install, test and tidy up
	@make clean test build
	@git add $(MODULE)/pyproject.toml
	@git commit -m "Release $(NEWVER)"
	@git tag -a "v$(NEWVER)" -m "Release $(NEWVER)"
	@git push
	@git push --tags
	@poetry publish
.PHONY: __release
