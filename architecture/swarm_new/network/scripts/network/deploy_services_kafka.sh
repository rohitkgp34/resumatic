#!/bin/bash

GLOBAL_ENV_LOCATION=$PWD/.env
source $GLOBAL_ENV_LOCATION
set -ev 
for i in {1..5}; do
     export BYFN_CA"${i}"_PRIVATE_KEY=$(ls /var/mynetwork/certs/crypto-config/peerOrganizations/org${i}.example.com/ca/ | grep _sk)
done

# KAFKA & ZOOKEEPER
docker stack deploy -c "$ZK_COMPOSE_PATH" hlf_zk 
sleep 3
docker stack deploy -c "$KAFKA_COMPOSE_PATH" hlf_kafka
sleep 3