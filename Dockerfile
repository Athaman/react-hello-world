FROM node:8.11.2-jessie

# Add NBN certs into the container
RUN apt-get update
RUN apt-get install -y make uuid-runtime
ADD https://apro.nbnco.net.au/cdtools-generic/nbncerts/openssl/all_cacerts.pem /tmp/
RUN mv /tmp/all_cacerts.pem /usr/local/share/ca-certificates/all_cacerts.crt
RUN update-ca-certificates
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# Configure NPM
RUN npm config set registry https://apro.nbnco.net.au/api/npm/npm-remote
RUN npm config set cafile /etc/ssl/certs/ca-certificates.crt

# Create app directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add env path
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# Copy package files for npm install before copying app files that are less volatile
COPY package*.json ./

# Install application dependencies
RUN npm install

# copy app files
COPY . .

EXPOSE 3000

CMD ["npm", "start"]
