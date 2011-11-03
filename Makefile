

amd/on.js: ./node_modules/.bin/commonjs-to-amd lib/on.js
	mkdir -p amd
	./node_modules/.bin/commonjs-to-amd lib/on.js > amd/on.js

test: node_modules/.bin/litmus
	node_modules/.bin/litmus tests/main.js

node_modules/.bin/litmus:
	npm install litmus

node_modules/.bin/commonjs-to-amd:
	npm install amdtools

clean:
	rm -rf $(AMD_DIR) node_modules

