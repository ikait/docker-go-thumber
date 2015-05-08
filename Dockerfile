FROM ubuntu:14.04

RUN \
  apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive

WORKDIR /src

RUN \
  apt-get install -y \
    wget \
    tar \
    git \
    gcc \
    libswscale-dev \
    libjpeg-turbo8-dev 

RUN \
  wget \
    https://storage.googleapis.com/golang/go1.3.linux-amd64.tar.gz && \
  tar \
    -C /usr/local \
    -xvzf go1.3.linux-amd64.tar.gz && \
  export PATH=$PATH:/usr/local/go/bin && \
  export GOPATH=/usr/local/go

RUN \
  mkdir -p "/usr/local/go/src/pkg/github.com/pixiv" && \
  cd "/usr/local/go/src/pkg/github.com/pixiv" && \
  git clone https://github.com/pixiv/go-thumber.git && \
  /usr/local/go/bin/go install github.com/pixiv/go-thumber/thumberd && \
  ln -s /usr/local/go/bin/thumberd /usr/local/bin/thumberd

EXPOSE 8081

CMD ["/usr/local/go/bin/thumberd", "-local", "localhost:8081"]
