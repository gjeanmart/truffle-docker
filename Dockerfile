FROM node:latest

MAINTAINER Gregoire Jeanmart version: 0.4

USER root

####################################################################################################################
# Install
#RUN apt-get update \
#    apt-get upgrade \
#    apt-get install git

RUN npm -g config set user root
RUN npm install -g truffle@4.1.13 && npm config set bin-links false
#RUN npm install -g truffle-hdwallet-provider@0.0.3 \
#				   ethereumjs-wallet@0.6.0 \ 
#				   ethereumjs-util@5.2.0 \
#				   openzeppelin-solidity@1.12.0

####################################################################################################################
# Env
ENV API_HOST "0.0.0.0"
ENV API_PORT "8888"
ENV NETWORK "development"
ENV SRC_DIR "/project"
#ENV GIT_URL ""
ENV GIT_BRANCH "master"

####################################################################################################################
# Create project directory
RUN mkdir -p $SRC_DIR


####################################################################################################################
# Scripts
ADD ./.scripts/run.sh /scripts/run.sh
ADD ./.scripts/package.json /scripts/package.json
ADD ./.scripts/api.js /scripts/api.js

RUN chmod +x /scripts/run.sh

####################################################################################################################
# Run
EXPOSE $API_PORT

WORKDIR $SRC_DIR

CMD ["/scripts/run.sh"]
