#!/usr/bin/env bash

echo "###### Running truffle-docker"

##################################################
### LOAD SOURCES
if [ ! -z "$GIT_URL" ]
then
	echo "[INFO] Clone data from git $GIT_URL (branch $GIT_BRANCH)..."
	rm -rf $SRC_DIR/* || exit_on_error "Failed to empty the source directory"
	git clone -b $GIT_BRANCH $GIT_URL $SRC_DIR || exit_on_error "Failed to clone the git repository $GIT_URL"
fi

##################################################
### INSTALL DEPENDANCIES
if [ -f "./package.json" ]
then
	echo "[INFO] Install dependancies ..."
	rm -rf  ./node_modules || exit_on_error "Failed to remove the node_modules repository"
	npm install || exit_on_error "Failed to install npm dependancies"
fi

##################################################
### RUN DEPLOYMENT
echo "[INFO] Deploy smart contract (truffle migrate --network $NETWORK) ..."
rm -rf ./build  || exit_on_error "Failed to remove the build repository"
output=$(truffle migrate --reset --compile-all --network $NETWORK)
echo "output: $output"

##################################################
### START API
echo "[INFO] Start express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install || exit_on_error "Failed to install npm dependancies"
node ./api.js || exit_on_error "Failed to rin api.js"