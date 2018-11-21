#!/usr/bin/env bash

echo "###### Running truffle-docker"

##################################################
### LOAD SOURCES
if [ ! -z "$GIT_URL" ]
then
	echo "[INFO] Clone data from git $GIT_URL (branch $GIT_BRANCH)..."
	
	if [ -f "/root/.ssh/id_rsa" ]
	then
		chmod 700 /root/.ssh/id_rsa
		chmod 600 /root/.ssh/id_rsa.pub
		echo -e "host github.com\n\tHostname github.com\n\tIdentityFile /root/.ssh/id_rsa\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
	fi

	rm -rf $SRC_DIR/* || { echo '[ERROR] Failed to empty the source directory' ; exit 1; }
	git clone -b $GIT_BRANCH $GIT_URL $SRC_DIR || { echo '[ERROR] Failed to clone the git repository $GIT_URL' ; exit 1; }
fi

##################################################
### INSTALL DEPENDANCIES
if [ -f "./package.json" ]
then
	echo "[INFO] Install dependancies ..."
	rm -rf  ./node_modules || { echo '[ERROR] Failed to remove the node_modules repository' ; exit 1; }
	npm install || { echo '[ERROR] Failed to install npm dependancies' ; exit 1; }
fi

##################################################
### RUN DEPLOYMENT
echo "[INFO] Deploy smart contract (truffle migrate --reset --compile-all --network $NETWORK) ..."
rm -rf ./build || { echo '[ERROR] Failed to remove the build repository' ; exit 1; }
output=$(truffle migrate --reset --compile-all --network $NETWORK) || { echo '[ERROR] Failed to deploy' ; exit 1; }
echo "output: $output"

##################################################
### START API
echo "[INFO] Start express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install || { echo '[ERROR] Failed to install npm dependancies' ; exit 1; }
node ./api.js || { echo '[ERROR] Failed to rin api.js' ; exit 1; }

