FROM golang

RUN apt-get update && apt-get install -y graphviz npm git zip percona-toolkit

RUN \
  wget https://github.com/tkuchiki/alp/releases/download/v1.0.12/alp_linux_amd64.zip -q -O /tmp/alp.zip && \
  unzip /tmp/alp.zip -d /tmp && \
  mv /tmp/alp /usr/local/bin

RUN \
  wget https://github.com/tkuchiki/slp/releases/download/v0.2.0/slp_linux_amd64.zip -q -O /tmp/slp.zip && \
  unzip /tmp/slp.zip -d /tmp && \
  mv /tmp/slp /usr/local/bin

RUN git clone https://github.com/ikura-hamu/pprotein.git /go/src/pprotein

WORKDIR /go/src/pprotein

COPY targets.json /go/src/pprotein/internal/collect/group/targets.json

RUN make build

ENTRYPOINT [ "make", "run" ]
