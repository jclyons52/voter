# Simple usage with a mounted data directory:
# > docker build -t voterapp .
#
# Server:
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.voterapp:/root/.voterapp voterapp voterd init
# TODO: need to set validator in genesis so start runs
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.voterapp:/root/.voterapp voterapp voterd start
#
# Client: (Note the voterapp binary always looks at ~/.voterapp we can bind to different local storage)
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.voterappcli:/root/.voterapp voterapp voterd keys add foo
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.voterappcli:/root/.voterapp voterapp voterd keys list
FROM golang:alpine AS builder

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN  go mod download
WORKDIR /app/cmd/voterd
RUN  go build

FROM alpine:edge

WORKDIR /root

COPY --from=builder /app/cmd/voterd/voterd /usr/bin/voterd

EXPOSE 26656 26657 1317 9090

CMD [ "voterd" ]
