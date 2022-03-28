FROM amazoncorretto:8-alpine3.15-jre
LABEL maintainer "Dylan Luttrell"
# arguments for service name, its directory, and version
ARG NAME=<SERVICE-NAME>
ARG DIR=<DIRECTORY>
ARG VERSION=<VERSION>
# copy from local dir to container
WORKDIR /app
COPY ${DIR}/target/${NAME}-${VERSION}.jar service.jar
# set enviroment variables for database dialect and modification mode
ENV DB_PLATFORM=org.hibernate.dialect.H2Dialect
ENV DDL_AUTO_MODE=create-only

EXPOSE 8071
CMD ["java", "-jar", "service.jar"]
