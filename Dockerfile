FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/spring-h2-demo.war /app/
EXPOSE 9090
CMD [ "java",".war","spring-h2-demo.war" ]
