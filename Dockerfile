# Minio docker container - Builds the latest Minio release on ARM
#
# Started with:
# https://github.com/alexellis/docker-arm/tree/master/images/armhf/minio
# But since Minio stopped releasing new ARM builds this is quite outdated, 
# so this now updates from source.

# BUILD:
# docker build -t minio-arm github.com/jessedyck/minio-arm.git
#
# RUN:
# docker run -p 9000:9000 \
# -v /timemachine/minio/data:/objects \
# -v /timemachine/minio/config:/root/.minio \
# -e "MINIO_ACCESS_KEY=B6NV1HUDFES2GQ50FKAD" \
# -e "MINIO_SECRET_KEY=Rp4z7hmvSGUFb3J/k0tWGtES+7zXGzIoctI5bKUg" \
# minio-arm

FROM arm32v7/debian:latest
WORKDIR /root/
RUN apt-get update && apt-get --yes install wget git gcc

# Set up Golang
# https://docs.minio.io/docs/how-to-install-golang
RUN wget https://dl.google.com/go/go1.10.3.linux-armv6l.tar.gz
RUN tar -C /usr/local -xzf go1.10.3.linux-armv6l.tar.gz
ENV PATH "$PATH:/usr/local/go/bin:${HOME}/go/bin"

# Get Minio source
RUN go get -u github.com/minio/minio
RUN mv ~/go/bin/minio /usr/bin/

EXPOSE 9000
RUN mkdir /data/
VOLUME /data/
RUN chmod +x /usr/bin/minio

CMD ["/usr/bin/minio", "server", "/data/"]
