DOCKER := $(shell { command -v podman || command -v docker; })

.PHONY: all clean distclean

all:
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
