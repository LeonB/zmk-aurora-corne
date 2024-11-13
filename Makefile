DOCKER := $(shell { command -v podman || command -v docker; })

.PHONY: firmware clean distclean
.FORCE: ;

all: firmware keymap.svg

firmware:
	$($(shell bin/get_version.sh >> /dev/null)
	$(DOCKER) build --tag zmk-build-user-config --build-arg USER_ID=$(shell id -u) .
	$(DOCKER) run --rm -it --name zmk-build-user-config \
		-v $(PWD)/build:/app/build \
        -v $(PWD)/build.yaml:/app/build.yaml:ro \
        -v $(PWD)/config:/app/config:ro \
        -v $(PWD)/firmware:/app/firmware \
        -e OUTPUT_ZMK_CONFIG=$(OUTPUT_ZMK_CONFIG) \
        zmk-build-user-config

clean:
	rm -rf firmware/[^.]*
	rm -rf build/[^.]*

distclean: clean
	-$(DOCKER) image rm zmk-build-user-config
	-$(DOCKER) system prune

config/keymap.yaml: keymap_drawer.yaml
	keymap -c keymap_drawer.yaml parse -c 10 -z config/splitkb_aurora_corne.keymap > config/keymap.yaml

keymap.svg: config/keymap.yaml .FORCE
	keymap -c keymap_drawer.yaml draw config/keymap.yaml > keymap.svg
