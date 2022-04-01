# Docker

```xml
Features: Standardised application packaging, multi-platform support, light-weight and isolation 

docker run -p 5000:8080 balaji1974/hello-world-java:0.0.1-RELEASE 

run -> run the container
-p -> Short form for --publish 
5000:8080 -> host port: container port
balaji1974/hello-world-java -> docker repository name
0.0,1-RELEASE -> tag or version of the repository 

docker run -d -p 5000:8080 balaji1974/hello-world-java:0.0.1-RELEASE -> To run docker image in a detached mode 

docker log <container id> -> to attach the console with the running docker image

docker images -> To see all the docker images 

docker container ls -> To see all the running containers 
docker container ls -a -> To see all the containers regardless of weather they are running or not  

docker container stop <container id> -> To stop a running container 

docker pull mysql -> will download the docker image to our local repo but this will not start the container after pull is complete 

docker search mysql -> Will search all the images matching the name mysql  (check and install only the official image)

docker image history balaji1974/hello-world-java:0.0.1.RELEASE -> To see the history of a specific image 
docker image history 100229ba687e -> To see history of a image using its tag name

docker image inspect 100229ba687e -> To see the details of an image using its tag 
docker image remove mysql -> Remove the docker image 
docker container stop mysql -> Stop the running container

docker container pause 832 -> To pause a running container
docker container unpause 832 -> To unpause a running container 

docker container inspect ff521fa58db3 -> To inspect a container 
docker container prune -> Remove all stopped containers

docker system -> docker system commands
docker system df -> docker system show disk usage 
docker system info -> docker system display system-wide information
docker system prune -a -> remove unused data, unused containers, networks, images (both dangling and unreferenced), and optionally, volumes.
docker system events -> Get real time events from the server


docker top 9009722eac4d -> Display the running processes of a container
docker stats 9009722eac4d -> Display a live stream of container(s) resource usage statistics

docker container run -p 5000:5000 -d -m 512m balaji1974/hello-world-java:0.0.1.RELEASE -> same as docker run command
docker container run -p 5000:5000 -d -m 512m --cpu-quota=50000  balaji1974/hello-world-java:0.0.1.RELEASE -> allocate a CPU quota and a memory limit

docker container stats 4faca1ea914e3e458 -> Display a live stream of container(s) resource usage statistics
docker stats 42f170966ce613d2a16d7404495 -> Display a live stream of container(s) resource usage statistics

```

## Build & Run a python docker image and push the image to docker hub

```xml
cd /balaji1974/git/devops-master-class/projects/hello-world/hello-world-python -> Go to the python project folder 
docker build -t balaji1974/hello-world-python:0.0.2.RELEASE . (the final dot is the build context)  -> Build the docker file 

Inspect the docker file content - 
FROM python:alpine3.10 -> Build from a python lightweight version 
WORKDIR /app -> make the working directory for the build as /app
COPY . /app -> Copy everything to the working directory
RUN pip install -r requirements.txt -> Like maven for java pip is for python which will build the python file checking for the requirements.txt file for all the needed dependencies 
EXPOSE 5000 -> Expose the application that was built to the outside world on port 5000
CMD python ./launch.py -> run the python file 

docker run -p 5000:5000 -d balaji1974/hello-world-python:0.0.2.RELEASE -> Run the built docker image 
docker history e66dc383f7a0 -> Display the full history of what happened with the image
docker push balaji1974/hello-world-python:0.0.2.RELEASE-> Push the image to the docker hub
```

## Build & Run a node.js docker image and push the image to docker hub

```xml
cd ../hello-world-nodejs/ -> Go to the node js project folder 
docker build -t balaji1974/hello-world-nodejs:0.0.2.RELEASE . -> (the final dot is the build context)  -> Build the docker file 

Inspect the docker file content - 
FROM node:8.16.1-alpine -> Build from a node js version 
WORKDIR /app  -> make the working directory for the build as /app
COPY . /app -> Copy everything to the working directory
RUN npm install -> Like maven for java npm is for node js package builder which will build the project 
EXPOSE 5000 -> Expose the application that was built to the outside world on port 5000
CMD node index.js -> run the node js file 

docker container run -d -p 5001:5000 balaji1974/hello-world-nodejs:0.0.2.RELEASE -> Run the built docker image 
docker push balaji1974/hello-world-nodejs:0.0.2.RELEASE -> Push the image to the docker hub 

```

## Build & Run a java docker image and push the image to docker hub: 

```xml
cd ../hello-world-java/ -> Go to the java project folder 
docker build -t balaji1974/hello-world-java:0.0.2.RELEASE .  -> (the final dot is the build context)  -> Build the docker file 


# Build a JAR File
FROM maven:3.6.3-jdk-8-slim AS stage1 -> Build java project from maven 
WORKDIR /home/app -> make the working directory for the build as /home/app
COPY . /home/app/  -> Copy everything to the working directory
RUN mvn -f /home/app/pom.xml clean package -> maven clean and create package , now the jar file has been created

# Create an Image (copy the jar file into the docker image)
FROM openjdk:8-jdk-alpine -> Create an image from open jdk
EXPOSE 5000 -> Expose the application to outside world in port 5000
COPY --from=stage1 /home/app/target/hello-world-java.jar hello-world-java.jar -> copy the jar file
ENTRYPOINT ["sh", "-c", "java -jar /hello-world-java.jar"] -> set the entry point to launch the jar file 

docker run -d -p 5002:5000 balaji1974/hello-world-java:0.0.2.RELEASE -> run the docker image that was built 
docker push balaji1974/hello-world-java:0.0.2.RELEASE -> Push the docker image to the docker container

```

```xml
CMD overrides the docker file with the command line arguments that is being supplied 
ENTRYPOINT will not have this override function of the CMD unless we use any argument called --entrypoint with our docker run command 

docker network ls -> To display the network details of docker
docker network inspect bridge -> To display the bridge network details. All running containers are part of the bridge network and do not talk to each other. To overcome this we need to start the container with --link parameter and a registered environment variable --env with the microservice url.  Eg. 

docker run -d -p 8100:8100 --env CURRENCY_EXCHANGE_SERVICE_HOST=http://currency-exchange --name=currency-conversion --link currency-exchange balaji1974/currency-conversion:0.0.1-RELEASE

docker network create currency-network -> Create a custom network 
docker run -d -p 8000:8000 --name=currency-exchange --network=currency-network balaji1974/currency-exchange:0.0.1-RELEASE -> Run the container on the custom network 
docker run -d -p 8100:8100 --env CURRENCY_EXCHANGE_SERVICE_HOST=http://currency-exchange --name=currency-conversion --network=currency-network balaji1974/currency-conversion:0.0.1-RELEASE > Run the container on the custom network 

```

## Docker Compose

```xml
docker-compose --version -> To check the version of docker compose 
docker-compose up -> Will run the docker-compose.yml file and start the container  
docker-compose up -d -> Will run the docker-compose.yml file and start the container in detached mode 
docker-compose down -> will bring the containers down, remove them and also remove the network that was created as part of the application.yml file 
docker-compose config -> Useful for validating the yaml file 
docker-compose images -> List of images used by the docker compose 
docker-compose ps -> List down the containers 
docker-compose top -> List down the top process in each of the containers 

docker build -t balaji1974/hello-world-java:0.0.1.RELEASE . -> Build an image from a Dockerfile
docker push balaji1974/hello-world-java:0.0.1.RELEASE -> Push an image or a repository to a registry

```
## Useful Tips

```xml
1. How to install tools like vi editor in docker container? 

Login into the container using the following command
docker exec -it <container> bash

apt-get update
apt-get install vim

2. Exporting and importing files from/to docker containers:
Eg. 
docker cp mysql:/etc/my.cnf . - Import the file from docker to the local folder where container name is 'mysql'
docker cp my.cnf mysql:/etc/my.cnf - Export it back to the container named 'mysql'

```

