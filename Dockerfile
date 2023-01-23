FROM eclipse-temurin:17-jre-alpine
COPY target/*.jar /
EXPOSE 8080
ENTRYPOINT java -jar *.jar