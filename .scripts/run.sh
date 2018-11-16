#!/usr/bin/env bash

echo "###### Running truffle-docker"

if [ ! -z "$GIT_URL" ]
then
	echo "[INFO] Clone data from git $GIT_URL (branch $GIT_BRANCH)..."
	rm -rf $SRC_DIR/*  || exit_on_error "Failed to empty the source directory"
	git clone -b $GIT_BRANCH $GIT_URL $SRC_DIR  || exit_on_error "Failed to clone the git repository $GIT_URL"
fi

##################################################

echo "[INFO] Install dependancies ..."
rm -rf ./build ./node_modules  || exit_on_error "Failed to remove the build repository"
npm install  || exit_on_error "Failed to install npm dependancies"

##################################################

echo "[INFO] Deploy smart contract (truffle migrate --network $NETWORK) ..."
output=$(truffle migrate --reset --compile-all --network $NETWORK)
echo "output: $output"

echo "[INFO] Start express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install
node ./api.js