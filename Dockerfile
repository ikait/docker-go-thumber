golang:wheezy

RUN \
  apt-get update && apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get install -y -qq --no-install-recommends \
    libswscale-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

RUN \
  wget \
    http://sourceforge.net/projects/libjpeg-turbo/files/1.4.0/libjpeg-turbo-official_1.4.0_amd64.deb/download && \
  dpkg \
    -i download && \
  rm download && \
  ln -s /opt/libjpeg-turbo/include/* /usr/include/ && \
  ln -s /opt/libjpeg-turbo/lib64/* /usr/lib/

RUN \
  mkdir -p "$GOPATH/src/github.com/pixiv" && \
  cd "$GOPATH/src/github.com/pixiv" && \
  git clone https://github.com/pixiv/go-thumber.git && \
  go install github.com/pixiv/go-thumber/thumberd

EXPOSE 8081

CMD ["bash", "-c", "thumberd -local=$(echo `ip r` | cut -d \" \" -f14-14):8081"]


