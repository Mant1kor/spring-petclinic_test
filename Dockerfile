FROM openjdk
COPY target/*.jar /
EXPOSE 8080
ENTRYPOINT ["sh" "-c" "java -jar *.jar"]