From ubuntu:18.04

RUN apt-get update
RUN apt-get install openjdk-11-jdk -y

ENTRYPOINT [ "java", "-version"]
