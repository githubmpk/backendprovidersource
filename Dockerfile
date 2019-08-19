FROM openjdk:8
COPY build/libs/pathproviderV3-0.0.1-SNAPSHOT.jar /
EXPOSE 8080
ENV environment ""
ENV userid ""
ENTRYPOINT ["java", "-Dspring.profiles.active=${environment}", "-jar", "pathproviderV3-0.0.1-SNAPSHOT.jar"]




