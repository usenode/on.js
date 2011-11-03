
test: node_modules/.bin/litmus
	node_modules/.bin/litmus tests/main.js

node_modules/.bin/litmus:
	npm install litmus

