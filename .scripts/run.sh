#!/usr/bin/env bash

echo "Running truffle-docker (action $ACTION) !"

if [ "$ACTION" = "migrate" ]
then
	echo "Migrating truffle project [network $NETWORK] ..."
	rm -rf ./build ./node_modules
	npm install
	output=$(truffle migrate --reset --compile-all --network $NETWORK)
	echo "output: $output"
fi


echo "Running express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install
node ./api.js