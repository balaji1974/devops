FROM openjdk:17-alpine 
EXPOSE 8080
ADD target/hello-world-0.0.3-SNAPSHOT.jar hello-world-0.0.3-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/hello-world-0.0.3-SNAPSHOT.jar"]