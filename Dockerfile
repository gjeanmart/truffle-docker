FROM node:8

USER root

####################################################################################################################
# Env
ENV VERSION "0.8"
ENV COMMAND "migrate"
ENV API_HOST "0.0.0.0"
ENV API_PORT "8888"
ENV NETWORK "development"
ENV SRC_DIR "/project"
ENV GIT_BRANCH "master"
ENV GIT_FOLDER "/"
ENV TRUFFLE_VERSION "5.0.10"

####################################################################################################################
# Install
RUN npm install -g truffle@$TRUFFLE_VERSION && npm config set bin-links false

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



MAINTAINER Gregoire Jeanmart version: $VERSION
