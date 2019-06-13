#!/bin/bash
GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION

set -ev
for i in {1..5}; do
     export BYFN_CA"${i}"_PRIVATE_KEY=$(ls /var/mynetwork/certs/crypto-config/peerOrganizations/org${i}.example.com/ca/ | grep _sk)
done
# ORG 3
sleep 3
docker stack deploy -c "$SERVICE_ORG3_COMPOSE_PATH" hlf_services
sleep 3
docker stack deploy -c "$PEER_ORG3_COMPOSE_PATH" hlf_peer

