#!/usr/bin/env bash

echo "###### Running truffle-docker [v. $VERSION]"

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
	git clone -b $GIT_BRANCH $GIT_URL $SRC_DIR  || { echo '[ERROR] Failed to clone the git repository $GIT_URL' ; exit 1; }
fi


##################################################
### NAVIGATE IN A SUBFOLDER IF REQUIRED
cd $SRC_DIR$GIT_FOLDER  || { echo '[ERROR] Cannot navigate to folder $SRC_DIR$GIT_FOLDER ' ; exit 1; }

##################################################
### INSTALL DEPENDANCIES
if [ -f "./package.json" ]
then
	echo "[INFO] Install dependencies ..."
	rm -rf  ./node_modules || { echo '[ERROR] Failed to remove the node_modules repository' ; exit 1; }
	npm install || { echo '[ERROR] Failed to install npm dependencies' ; exit 1; }
fi

##################################################
### RUN TRUFFLE COMMAND
rm -rf ./build || { echo '[ERROR] Failed to remove the build repository' ; exit 1; }
if [ $COMMAND = "compile" ];
then
	echo "[INFO] Compile smart contracts (truffle compile) ..."
	output=$(truffle compile) || { echo '[ERROR] Failed to compile' ; exit 1; }
else
	echo "[INFO] Deploy smart contracts (truffle migrate --reset --compile-all --network $NETWORK) ..."
	output=$(truffle migrate --reset --compile-all --network $NETWORK) || { echo '[ERROR] Failed to migrate' ; exit 1; }
fi
echo "output: $output"


##################################################
### START API
echo "[INFO] Start express (host: $API_HOST, port: $API_PORT)"
cd /scripts
npm install || { echo '[ERROR] Failed to install npm dependancies' ; exit 1; }
node ./api.js || { echo '[ERROR] Failed to rin api.js' ; exit 1; }
