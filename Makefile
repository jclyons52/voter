network?=testnet 
moniker?=node1 
validator?=joe 
keyring?=file 
stake?=100000000stake

BUILDDIR ?= $(CURDIR)/build
DOCKER_CMD=docker run -it --rm -p 26657:26657 -p 26656:26656 -p 1317:1317 -p 9090:9090 -v $(CURDIR)/build/.voter:/root/.voter jclyons52/voter

# install dependencies
install:
	go mod download
#build binary for linux
build-linux:
	LEDGER_ENABLED=false GOOS=linux GOARCH=amd64 go build -o ./build ./cmd/voterd
# build the docker image
docker-build:
	docker build -t jclyons52/voter .
build-docker-voterdnode:
	$(MAKE) -C networks/local
init-testnet:
	${DOCKER_CMD} voterd testnet --v 4 -o . --starting-ip-address 192.168.10.2 --keyring-backend=test
	docker-compose up -d
localnet-start: build-linux
	@if ! [ -f build/node0/voterd/config/genesis.json ]; then docker run --rm -v $(CURDIR)/build:/voterd:Z jclyons52/voterdnode testnet --v 4 -o . --starting-ip-address 192.168.10.2 --keyring-backend=test ; fi
	docker-compose up -d
# Stop testnet
localnet-stop:
	docker-compose down
# upload executable to server
upload:
	scp ./cmd/voterd root@178.128.86.73:.
# initialize the configuration for the node
init:
	${DOCKER_CMD} voterd init ${moniker} --chain-id ${network}
# generate a new key for the validator
add-key:
	${DOCKER_CMD} voterd keys add ${validator} --keyring-backend ${keyring}
# retrieve keys stored in keychain
show-keys:
	${DOCKER_CMD} voterd keys show ${validator} -a --keyring-backend ${keyring}
# populate the state with an account
add-genesis-account:
	${DOCKER_CMD} voterd add-genesis-account ${MY_VALIDATOR_ADDRESS} ${stake}
# Validators can be declared before a chain is first started via a special transaction included in the genesis file called a gentx
gentx:
	${DOCKER_CMD} voterd gentx ${validator} ${stake} --chain-id ${network} --keyring-backend ${keyring}
# Add the gentx to the genesis file.
collect-gentx:
	${DOCKER_CMD} voterd collect-gentxs
# start the node
start:
	${DOCKER_CMD} voterd start
# clear the persisted volume containing the configuration for the node
clear-config:
	rm -R ~/.voter
