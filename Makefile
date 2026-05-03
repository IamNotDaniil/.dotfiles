SHELL := /usr/bin/env bash
DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

.PHONY: help install update clean backup doctor

help:
	@echo "Available commands:"
	@echo "  make install - install dotfiles (backup + symlinks + plugins)"
	@echo "  make update  - pull latest changes and re-run install"
	@echo "  make clean   - remove symlinks managed by this repo"
	@echo "  make backup  - backup existing dotfiles with rotation"
	@echo "  make help    - show this help"

install:
	@DOTFILES_DIR="$(DOTFILES_DIR)" bash scripts/install.sh

update:
	@git pull --rebase
	@$(MAKE) install

clean:
	@DOTFILES_DIR="$(DOTFILES_DIR)" bash scripts/install.sh --clean

backup:
	@bash scripts/backup.sh


doctor:
	@bash scripts/doctor.sh
