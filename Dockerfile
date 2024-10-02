# Use the official OpenJDK as a base image
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the specified path on your system to the container
COPY ./SpringApp-0.0.1-SNAPSHOT.jar /app/SpringApp.jar

# Expose the port your app runs on
EXPOSE 8999

# Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "/app/SpringApp.jar"]

