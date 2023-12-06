# Stage 1: Build stage
FROM ubuntu:22.04 as build-stage

# install necessary packages for building the application
RUN apt-get update && apt-get install -y wget maven

# install jdk 21.0.1
RUN wget https://download.java.net/java/GA/jdk21.0.1/415e3f918a1f4062a0074a2794853d0d/12/GPL/openjdk-21.0.1_linux-x64_bin.tar.gz -P /tmp && \
    tar -xvf /tmp/openjdk-21.0.1_linux-x64_bin.tar.gz -C /usr/local && \
    rm -f /tmp/openjdk-21.0.1_linux-x64_bin.tar.gz

# set the JAVA_HOME environment variable
ENV JAVA_HOME=/usr/local/jdk-21.0.1
ENV PATH="$JAVA_HOME/bin:$PATH"

# copy the pom.xml file and source code
COPY myapp/pom.xml /tmp/
COPY myapp/src /tmp/src
COPY myapp-1.0.1.jar /tmp

# build all dependencies
WORKDIR /tmp
RUN mvn clean package

# Stage 2: Run stage
FROM ubuntu:22.04

# install jdk 21.0.1
COPY --from=build-stage /usr/local/jdk-21.0.1 /usr/local/jdk-21.0.1

# set java environment variable
ENV JAVA_HOME=/usr/local/jdk-21.0.1
ENV PATH="$JAVA_HOME/bin:$PATH"

# create a new user 'omri' and switch to it
RUN useradd -m omri
USER omri
WORKDIR /home/omri

# copy the built jar from the build stage
COPY --from=build-stage --chown=omri /tmp/myapp-1.0.1.jar /home/omri/

# set the entrypoint
ENTRYPOINT ["java", "-jar", "/home/omri/myapp-1.0.1.jar"]
