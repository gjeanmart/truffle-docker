FROM node:latest

MAINTAINER Gregoire Jeanmart version: 0.3

USER root

####################################################################################################################
# Install
RUN npm -g config set user root
RUN npm install -g truffle@4.1.13 && npm config set bin-links false
RUN npm install --global truffle-hdwallet-provider@0.0.3 \
						 ethereumjs-wallet@0.6.0 \ 
						 ethereumjs-util@5.2.0 \
						 openzeppelin-solidity@1.12.0

####################################################################################################################
# Env
ENV API_PORT 8888

####################################################################################################################
# Create project directory
RUN mkdir /project


####################################################################################################################
# Scripts
ADD ./.scripts/run.sh /scripts/run.sh
ADD ./.scripts/package.json /scripts/package.json
ADD ./.scripts/api.js /scripts/api.js

RUN chmod +x /scripts/run.sh

####################################################################################################################
# Run
EXPOSE $API_PORT

WORKDIR /project

CMD ["/scripts/run.sh"]
