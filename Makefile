
all: test amd global.js

amd: patches/debug.patch patches/named.patch lib/on.js node_modules/.bin/uglifyjs
	set -e
	mkdir -p amd
	cp lib/on.js amd/on.debug.js
	patch amd/on.debug.js patches/debug.patch
	cp lib/on.js amd/on.named.debug.js
	patch amd/on.named.debug.js patches/named.patch
	node_modules/.bin/uglifyjs amd/on.debug.js > amd/on.js
	node_modules/.bin/uglifyjs amd/on.named.debug.js > amd/on.named.js

global.js: patches/global.patch lib/on.js node_modules/.bin/uglifyjs
	cp lib/on.js on.global.debug.js
	patch on.global.debug.js patches/global.patch
	node_modules/.bin/uglifyjs on.global.debug.js > on.global.js 

node_modules/.bin/uglifyjs:
	npm install uglify-js

test: node_modules/.bin/litmus
	node_modules/.bin/litmus tests/main.js

node_modules/.bin/litmus:
	npm install litmus

publish: 
	perl -e '`git status` =~ /working directory clean/ or die "cannot publish without clean working dir\n"' && \
	echo current version is `perl -ne 'print /"version"\s*:\s*"(\d+\.\d+\.\d+)"/' package.json` && \
	perl -e 'print "new version? "' && \
	read new_version && \
	perl -i -pe 's/("version"\s*:\s*\")(?:|\d+\.\d+\.\d+)(")/$$1."'$$new_version'".$$2/e' package.json && \
	git commit -m 'Version for release' package.json && \
	git tag v$$new_version && \
	git push origin master && \
	git push --tags && \
	npm publish https://github.com/tomyan/on.js/tarball/v$$new_version

clean:
	rm -rf amd node_modules

