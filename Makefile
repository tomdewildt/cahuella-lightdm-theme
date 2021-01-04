.PHONY: install uninstall
.DEFAULT_GOAL := help

NAMESPACE := tomdewildt
NAME := cahuella-lightdm-theme

THEME_NAME := cahuella
THEME_DIR := /usr/share/lightdm/lightdm-gtk-greeter.conf.d
BACKGROUND_NAME := regolith-structure-7
BACKGROUND_EXT := png
BACKGROUND_DIR := /usr/share/backgrounds

help: ## Show this help
	@echo "${NAMESPACE}/${NAME}"
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | \
	fgrep -v fgrep | sed -e 's/## */##/' | column -t -s##

##

install: ## Install theme
	@echo "INFO: Inspecting '${THEME_DIR}'"
	$(eval THEME_NUMBER := $(shell ls ${THEME_DIR} | grep -v ${THEME_NAME} | tail -1 | awk -F '[_]' '{ print $$1; }'))
	$(eval THEME_NUMBER := $(shell printf '%02d' $$((${THEME_NUMBER}+1))))

	@echo "INFO: Copying '${BACKGROUND_NAME}' to '${BACKGROUND_DIR}'"
	@sudo cp -rf ./${THEME_NAME}/${BACKGROUND_NAME}.${BACKGROUND_EXT} ${BACKGROUND_DIR}/${BACKGROUND_NAME}.${BACKGROUND_EXT}

	@echo "INFO: Copying '${THEME_NAME}' to '${THEME_DIR}'"
	@sudo cp -rf ./${THEME_NAME}/${THEME_NAME}.conf ${THEME_DIR}/${THEME_NUMBER}_${THEME_NAME}.conf

uninstall: ## Uninstall theme
	@echo "INFO: Removing '${THEME_NAME}' from '${THEME_DIR}'"
	$(eval THEME_NUMBER := $(shell ls ${THEME_DIR} | grep ${THEME_NAME} | awk -F '[_]' '{ print $$1; }'))
	@if [ ! -z "${THEME_NUMBER}" ]; then \
		sudo rm -f ${THEME_DIR}/${THEME_NUMBER}_${THEME_NAME}.conf; \
	fi

	@echo "INFO: Removing '${BACKGROUND_NAME}' from '${BACKGROUND_DIR}'"
	@sudo rm -f ${BACKGROUND_DIR}/${BACKGROUND_NAME}.${BACKGROUND_EXT};
