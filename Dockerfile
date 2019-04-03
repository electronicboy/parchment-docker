FROM openjdk:8-jdk-slim-stretch
LABEL maintainer="Shane Freeder <theboyetronic@gmail.com>"

RUN apt-get update \
        && apt-get install -y jq curl \
        && apt-get clean \
        && useradd -m -d /home/server server \
        && mkdir -p /home/server/root \
        && chown server /home/server/root


USER server
ENV USER=server HOME=/home/server USER.HOME=/home/server/root

WORKDIR /home/server

ADD bootstrap.sh /

ENV version=latest
EXPOSE 25565

WORKDIR /home/server
VOLUME [ "/home/server/root" ]

CMD ["sh", "/bootstrap.sh"]
