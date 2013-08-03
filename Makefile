
.PHONY: test publish release upload

VERSION=DEV

test: node_modules/.bin/litmus
	node_modules/.bin/litmus tests/main.js

publish: release upload

release: all
	scripts/release

upload: all
	scripts/upload

dist: on-v$(VERSION).tar.gz

on-v$(VERSION).tar.gz: all
	cp -r target on-v$(VERSION)
	tar czf $@ on-v$(VERSION)
	rm -rf on-v$(VERSION)

all: test target/package.json target/README.md target/lib/on.js \
	 target/amd/on.js target/amd/on.debug.js \
	 target/amd/on.named.js target/amd/on.named.debug.js \
	 target/global/on.global.debug.js target/global/on.global.js

target/package.json: package.json 
	mkdir -p target
	cp $< $@

target/README.md: README.md
	mkdir -p target
	cp $< $@

target/lib/on.js: lib/on.js
	mkdir -p target/lib
	cp $< $@

target/amd/on.debug.js: lib/on.js patches/debug.patch
	mkdir -p target/amd
	cp $< $@
	patch $@ patches/debug.patch 

target/amd/on.js: node_modules/.bin/uglifyjs target/amd/on.debug.js
	mkdir -p target/amd
	$^ > $@

target/amd/on.named.debug.js: lib/on.js patches/named.patch
	mkdir -p target/amd
	cp $< $@
	patch $@ patches/named.patch

target/amd/on.named.js: node_modules/.bin/uglifyjs target/amd/on.named.debug.js
	mkdir -p target/amd
	$^ > $@

target/global/on.global.debug.js: lib/on.js patches/global.patch
	mkdir -p target/global
	cp $< $@
	patch $@ patches/global.patch

target/global/on.global.js: node_modules/.bin/uglifyjs target/global/on.global.debug.js
	mkdir -p target/global
	$^ > $@

node_modules/.bin/uglifyjs:
	npm install uglify-js

node_modules/.bin/litmus:
	npm install litmus

clean:
	rm -rf target node_modules

