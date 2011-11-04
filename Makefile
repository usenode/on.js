

amd/on.js: ./node_modules/.bin/commonjs-to-amd lib/on.js
	mkdir -p amd
	./node_modules/.bin/commonjs-to-amd lib/on.js > amd/on.js

test: node_modules/.bin/litmus
	node_modules/.bin/litmus tests/main.js

node_modules/.bin/litmus:
	npm install litmus

node_modules/.bin/commonjs-to-amd:
	npm install amdtools

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
	rm -rf $(AMD_DIR) node_modules

