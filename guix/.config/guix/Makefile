export GUILE_LOAD_PATH := $(GUILE_LOAD_PATH):./guix-home:$(HOME)/src/rde


.PHONY: andriy-home
andriy-home:
	guix home reconfigure ./guix-home/home/andriy/core.scm

.PHONY: andriy-system
andriy-system:
	sudo -E guix system reconfigure ./system/config.scm
