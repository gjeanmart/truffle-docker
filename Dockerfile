FROM node:latest

MAINTAINER Gregoire Jeanmart version: 0.2

####################################################################################################################
# Install
RUN npm install -g truffle && npm config set bin-links false

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
