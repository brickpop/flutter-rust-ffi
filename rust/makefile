.DEFAULT_GOAL := help
PROJECTNAME=$(shell basename "$(PWD)")
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))
CARGO_CONFIG=$(HOME)/.cargo/config

SHELL := /bin/bash

# ##############################################################################
# # GENERAL
# ##############################################################################

.PHONY: help
help: makefile
	@echo
	@echo " Available actions in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## init: Install missing dependencies.
.PHONY: init
init: $(CARGO_CONFIG)
	rustup target add aarch64-apple-ios armv7-apple-ios armv7s-apple-ios x86_64-apple-ios i386-apple-ios
	rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android
	@if [ $$(uname) == "Darwin" ] ; then cargo install cargo-lipo ; fi
	cargo install --force cbindgen

$(CARGO_CONFIG):
	@if [ ! -f $(CARGO_CONFIG) ] ; then echo -e "\nNOTE: Adapt cargo-config.toml and append it to $(CARGO_CONFIG)\n" ; fi

## :

# ##############################################################################
# # RECIPES
# ##############################################################################

## all: Compile iOS, Android and bindings targets
all: ios android bindings

## ios: Compile the iOS universal library
ios: target/universal/release/libexample.a

target/universal/release/libexample.a: $(SOURCES) $(CARGO_CONFIG)
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi

## android: Compile the android targets (arm64, armv7 and i686)
android: target/aarch64-linux-android/release/libexample.so target/armv7-linux-androideabi/release/libexample.so target/i686-linux-android/release/libexample.so

target/aarch64-linux-android/release/libexample.so: $(SOURCES) $(CARGO_CONFIG)
	cargo build --target aarch64-linux-android --release

target/armv7-linux-androideabi/release/libexample.so: $(SOURCES) $(CARGO_CONFIG)
	cargo build --target armv7-linux-androideabi --release

target/i686-linux-android/release/libexample.so: $(SOURCES) $(CARGO_CONFIG)
	cargo build --target i686-linux-android --release

## bindings: Generate the .h file for Objective C
bindings: target/bindings.h

target/bindings.h: target/bindings-original.h
	cat $< | grep -v \#include | uniq > $@

target/bindings-original.h: $(SOURCES)
	cbindgen $^ -c cbindgen.toml -o $@

## :

# ##############################################################################
# # OTHER
# ##############################################################################

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -f target/bindings.h target/bindings-original.h

## test:
.PHONY: test
test:
	cargo test
