network?=testnet 
moniker?=node1 
validator?=alice 
keyring?=file 
stake?=100000000stake

DOCKER_CMD=docker run -it -p 26657:26657 -p 26656:26656 -p 1317:1317 -p 9090:9090 -v ~/.voter:/root/.voter voterapp

# build the docker image
docker-build:
	docker build -t voterapp .
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
