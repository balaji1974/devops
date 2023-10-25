#below image for MAC
#FROM openjdk:17-alpine 
# below image for linux
FROM openjdk:17-ea-16-jdk 
EXPOSE 8080
ADD target/hello-world-0.0.4-SNAPSHOT.jar hello-world-0.0.4-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/hello-world-0.0.4-SNAPSHOT.jar"]