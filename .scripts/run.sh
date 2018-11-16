#!/usr/bin/env bash

echo "Running truffle-docker"

if [ ! -z "$GIT_URL" ]
then
	echo "Cloning data from git $GIT_URL (branch $GIT_BRANCH)..."
	git clone -b $GIT_BRANCH $GIT_URL $SRC_DIR
fi

echo "Migrating truffle project [network $NETWORK] ..."
rm -rf ./build ./node_modules
npm install
output=$(truffle migrate --reset --compile-all --network $NETWORK)
echo "output: $output"

echo "Running express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install
node ./api.js