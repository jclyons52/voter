FROM golang:alpine AS builder

ENV network testnet
ENV moniker node1
ENV validator alice
ENV keyring test
ENV stake 100000000stake

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN  go mod download
WORKDIR /app/cmd/voterd
RUN  go build
RUN ./voterd init ${moniker} --chain-id ${network}
RUN ./voterd keys add ${validator} --keyring-backend ${keyring}
RUN ./voterd add-genesis-account $(./voterd keys show ${validator} -a --keyring-backend ${keyring}) ${stake}
RUN ./voterd gentx ${validator} ${stake} --chain-id ${network} --keyring-backend ${keyring}
RUN ./voterd collect-gentxs


CMD [ "./voterd", "start" ]
