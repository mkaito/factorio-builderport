PACKAGE_NAME := $(shell cat info.json|jq -r .name)
VERSION_STRING := $(shell cat info.json|jq -r .version)
OUTPUT_NAME := $(PACKAGE_NAME)_$(VERSION_STRING)
BUILD_DIR := .build
OUTPUT_DIR := $(BUILD_DIR)/$(OUTPUT_NAME)
CONFIG = ./$(OUTPUT_DIR)/config.lua
MODS_DIRECTORY := $(HOME)/.factorio/mods
MOD_DIR := $(MODS_DIRECTORY)/$(OUTPUT_NAME)
##MOD_LINK := $(shell find $(MODS_DIRECTORY)/$(OUTPUT_NAME) -mindepth 1 -maxdepth 1 -type d)

PKG_COPY := $(wildcard *.md) $(wildcard .*.md) $(wildcard graphics) $(wildcard locale) $(wildcard sounds)

SED_FILES := $(shell find . -iname '*.json' -type f -not -path "./.*/*") $(shell find . -iname '*.lua' -type f -not -path "./.*/*")

OUT_FILES := $(SED_FILES:%=$(OUTPUT_DIR)/%)

SED_EXPRS := -e 's/{{MOD_NAME}}/$(PACKAGE_NAME)/g'
SED_EXPRS += -e 's/{{VERSION}}/$(VERSION_STRING)/g'

##@luac -p $@
##@luacheck $@

all: package

release: clean check package tag

package-copy: $(PKG_DIRS) $(PKG_FILES) $(OUT_FILES)
	mkdir -p $(OUTPUT_DIR)
ifneq ($(strip $(PKG_COPY)),)
	cp -r $(PKG_COPY) $(OUTPUT_DIR)
endif

$(OUTPUT_DIR)/%.lua: %.lua
	@mkdir -p $(@D)
	@sed $(SED_EXPRS) $< > $@


$(OUTPUT_DIR)/%: %
	@mkdir -p $(@D)
	@sed $(SED_EXPRS) $< > $@

## Make actual folder, then symlink things inside
# Factorio will refuse to load the mod if the actual mod folder is a symlink,
# but appears to load symlinks inside mod folder just fine.
symlink: package-copy cleandest
	mkdir -p $(MOD_DIR)
	ln -st $(MOD_DIR) $(PWD)/$(OUTPUT_DIR)/*

tag:
	git tag -f v$(VERSION_STRING)

nodebug:
	@[ -e $(CONFIG) ] && \
	echo Removing debug switches from config.lua && \
	sed -i 's/^\(.*DEBUG.*=\).*/\1 false/' $(CONFIG) && \
	sed -i 's/^\(.*LOGLEVEL.*=\).*/\1 0/' $(CONFIG) && \
	sed -i 's/^\(.*loglevel.*=\).*/\1 0/' $(CONFIG) || \
	echo No Config Files

check:
	@luacheck . -q --codes

package: package-copy $(OUT_FILES) nodebug
	@cd $(BUILD_DIR) && zip -rq $(OUTPUT_NAME).zip $(OUTPUT_NAME)
	@echo $(OUTPUT_NAME).zip ready

install: package cleandest
	cp $(BUILD_DIR)/$(OUTPUT_NAME).zip $(MOD_DIR).zip

clean:
	@rm -rf $(BUILD_DIR)
	@echo Removing Build Directory.

cleandest:
	rm -rf $(MODS_DIRECTORY)/$(PACKAGE_NAME)*
