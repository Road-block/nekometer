ADDON_NAME := nekometer
ADDON_VERSION := $(shell grep '## Version' nekometer.toc | cut -d ' ' -f 3)

WOW_FLAVOR ?= retail
WOW_ADDON_DIR ?=
# WOW_FLAVOR: retail, classic, classic_era, anniversary, etc
ifeq ($(strip $(WOW_ADDON_DIR)),)
ADDON_DIR := $(shell dirname `find ~ -path "*/_$(WOW_FLAVOR)_/Wow*.exe" 2>/dev/null | head -1`)/Interface/AddOns
else
ADDON_DIR := $(WOW_ADDON_DIR)
endif

install: uninstall
	mkdir -p "$(ADDON_DIR)/$(ADDON_NAME)"
	cp -rf . "$(ADDON_DIR)/$(ADDON_NAME)"

uninstall:
	rm -rf "$(ADDON_DIR)/$(ADDON_NAME)"

release: clean
	mkdir -p dist/$(ADDON_NAME)
	rsync -av \
		--exclude=".*" \
		--exclude="*_test.lua" \
		--exclude="assets/" \
		--exclude="dist" \
		. dist/$(ADDON_NAME)
	cd dist && zip -r $(ADDON_NAME)_v$(ADDON_VERSION).zip $(ADDON_NAME)/*

clean:
	rm -rf dist/*
