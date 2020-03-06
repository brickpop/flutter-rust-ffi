.DEFAULT_GOAL := help
PROJECTNAME=$(shell basename "$(PWD)")
SOURCES=$(sort $(wildcard ./src/*.rs ./src/**/*.rs))

ANDROID_AARCH64_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(shell uname | tr '[:upper:]' '[:lower:]')-x86_64/bin/aarch64-linux-android26-clang
ANDROID_ARMV7_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(shell uname | tr '[:upper:]' '[:lower:]')-x86_64/bin/armv7a-linux-androideabi26-clang
ANDROID_I686_LINKER=$(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/$(shell uname | tr '[:upper:]' '[:lower:]')-x86_64/bin/i686-linux-android26-clang

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
init:
	rustup target add aarch64-apple-ios armv7-apple-ios armv7s-apple-ios x86_64-apple-ios i386-apple-ios
	rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android
	@if [ $$(uname) == "Darwin" ] ; then cargo install cargo-lipo ; fi
	cargo install cbindgen

## :

# ##############################################################################
# # RECIPES
# ##############################################################################

## all: Compile iOS, Android and bindings targets
all: ios android bindings

## ios: Compile the iOS universal library
ios: target/universal/release/libexample.a

target/universal/release/libexample.a: $(SOURCES) ndk-home
	@if [ $$(uname) == "Darwin" ] ; then \
		cargo lipo --release ; \
		else echo "Skipping iOS compilation on $$(uname)" ; \
	fi

## android: Compile the android targets (arm64, armv7 and i686)
android: target/aarch64-linux-android/release/libexample.so target/armv7-linux-androideabi/release/libexample.so target/i686-linux-android/release/libexample.so

target/aarch64-linux-android/release/libexample.so: $(SOURCES) ndk-home
	CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$(ANDROID_AARCH64_LINKER) cargo build --target aarch64-linux-android --release

target/armv7-linux-androideabi/release/libexample.so: $(SOURCES) ndk-home
	CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=$(ANDROID_ARMV7_LINKER) cargo build --target armv7-linux-androideabi --release

target/i686-linux-android/release/libexample.so: $(SOURCES) ndk-home
	CARGO_TARGET_I686_LINUX_ANDROID_LINKER=$(ANDROID_I686_LINKER) cargo  build --target i686-linux-android --release

.PHONY: ndk-home
ndk-home:
	@if [ ! -d "${ANDROID_NDK_HOME}" ] ; then \
		echo "Error: Please, set the ANDROID_NDK_HOME env variable to point to your NDK folder" ; \
		exit 1 ; \
	fi

## bindings: Generate the .h file for iOS
bindings: target/bindings.h

target/bindings.h: target/bindings.src.h
	cat $< | grep -v \#include | uniq > $@

target/bindings.src.h: $(SOURCES)
	cbindgen $^ -c cbindgen.toml -o $@

## :

# ##############################################################################
# # OTHER
# ##############################################################################

## clean:
.PHONY: clean
clean:
	cargo clean
	rm -f target/bindings.h target/bindings.src.h

## test:
.PHONY: test
test:
	cargo test
