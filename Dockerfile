# We need a base image to build upon. Use the latest node image from
# dockerhub as the base image so we get node and npm for free
FROM node:latest
MAINTAINER Keone Martin

# Store all our app code in the /src folder, starting from package.json
# first. Why copy package.json first? So we can take advantage of
# the docker build cache. More below.
COPY package.json /src/package.json

# Once we have package.json, do npm install (restricting the loglevel
# to minimise noise)
RUN cd /src && npm install --loglevel error

# Copy all our code (yes including package.json again) to /src.
COPY . /src

# Change directory into the /src folder so we can execute npm commands
WORKDIR /src

# This is the express port on which our app runs
EXPOSE 3000

# This is the default command to execute when docker run is issued. Only
# one CMD instruction is allowed per Dockerfile.
CMD npm start
