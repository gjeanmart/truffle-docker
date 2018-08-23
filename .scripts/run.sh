#!/usr/bin/env bash

echo "Running truffle-docker (action $ACTION) !"

if [ "$ACTION" = "migrate" ]
then
	echo "Migrating truffle project [network $NETWORK] ..."
	rm -rf ./build
	output=$(truffle migrate --reset --compile-all --network $NETWORK)
	export CONTRACT_ADDRESS=$(echo "$output" | grep "^$CONTRACT_NAME address:" | sed "s/$CONTRACT_NAME address: //")
	echo "CONTRACT_ADDRESS=$CONTRACT_ADDRESS"
fi


echo "Running express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install
node ./api.js