# Minio docker container - Builds the latest Minio release on ARM
#
# Started with:
# https://github.com/alexellis/docker-arm/tree/master/images/armhf/minio
# But since Minio stopped releasing new ARM builds this is quite outdated, 
# so this now builds from source.

# BUILD:
# docker build -t minio-arm github.com/jessedyck/minio-arm.git
#
# RUN:
# docker run -d -p 9000:9000 \
# -v /timemachine/minio/data:/data \
# -v /timemachine/minio/config:/root/.minio \
# -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
# -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
# minio-arm /usr/bin/minio server /data/


FROM arm32v7/debian:latest
WORKDIR /root/
RUN apt-get update && apt-get --yes install wget git gcc make

# Set up Golang
# https://docs.minio.io/docs/how-to-install-golang
RUN wget https://dl.google.com/go/go1.13.7.linux-armv6l.tar.gz 
RUN tar -C /usr/local -xzf go1*.tar.gz
ENV PATH "$PATH:/usr/local/go/bin:${HOME}/go/bin"

# Get Minio source
RUN GO111MODULE=on go get github.com/minio/minio
RUN mv ~/go/bin/minio /usr/bin/

# Get and build minio client
RUN go get -d github.com/minio/mc
WORKDIR /root/go/src/github.com/minio/mc
RUN make
RUN mv ./mc /usr/bin
RUN chmod +x /usr/bin/mc

EXPOSE 9000
RUN mkdir /data/
VOLUME /data/
RUN chmod +x /usr/bin/minio
