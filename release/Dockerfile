FROM gliderlabs/alpine:latest

# build-base
RUN apk add --no-cache build-base

# go
RUN apk add --no-cache go
RUN mkdir /go
ENV GOPATH /go

# glide
RUN apk add --no-cache --virtual=glide-deps curl ca-certificates && \
    mkdir /tmp/glide && \
    curl -L https://github.com/Masterminds/glide/releases/download/v0.13.1/glide-v0.13.1-linux-amd64.tar.gz | tar -xzv -C /tmp/glide && \
    apk del glide-deps && \
    mv /tmp/glide/**/glide /bin/glide
