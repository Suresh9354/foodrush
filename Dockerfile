# Stage 1: Build FoodRush application using Maven and Java 17
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven configuration first
COPY pom.xml .

# Download project dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build WAR file
RUN mvn clean package -DskipTests


# Stage 2: Run application using Tomcat 10.1
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy FoodRush WAR as ROOT.war
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Render uses PORT environment variable
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]