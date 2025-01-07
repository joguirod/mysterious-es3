FROM ubuntu:latest as build

RUN apt-get update
RUN apt-get install openjdk-17-jdk -y
# copia o que tá dentro do projeto para o container
COPY . .

RUN apt-get install maven -y
RUN mvn clean install

FROM openjdk:17-jdk-slim

EXPOSE 8080

COPY --from=build /target/mysteriousapi-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT [ "java", "-jar", "app.jar" ]