# Specify a base image
FROM node:alpine

# go to the project working directory - make a work directory inside the container 
WORKDIR "/app"

# copy the package.json file to run npm install first 
# By this we seperate this config from the actual change 
# that will happen in the index.js and this step will not 
# be repeated unncessarly with every change to this file 
COPY package.json .

# Install depenendencies of npm
RUN npm install

# copy files from local PC into the docker container 
COPY . .

# Default command
CMD ["npm",  "start"]