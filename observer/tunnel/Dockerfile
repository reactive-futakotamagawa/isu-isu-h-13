FROM alpine:latest

RUN apk update && apk add openssh

COPY ./key /root/.ssh

RUN chmod 700 /root/.ssh

ENTRYPOINT [ "ssh" ]
