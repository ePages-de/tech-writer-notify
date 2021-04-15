FROM ubuntu:20.04

RUN apt update
RUN apt install -y git curl

COPY lib /lib
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
