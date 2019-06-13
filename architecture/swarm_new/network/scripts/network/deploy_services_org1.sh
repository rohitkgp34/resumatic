#!/bin/bash

GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION
set -ev 
for i in {1..5}; do
     export BYFN_CA"${i}"_PRIVATE_KEY=$(ls /var/mynetwork/certs/crypto-config/peerOrganizations/org${i}.example.com/ca/ | grep _sk)
done
# ORG 1

docker stack deploy -c "$ORDERER0_COMPOSE_PATH" hlf_orderer
sleep 3
docker stack deploy -c "$SERVICE_ORG1_COMPOSE_PATH" hlf_services
sleep 3
docker stack deploy -c "$PEER_ORG1_COMPOSE_PATH" hlf_peer
sleep 3