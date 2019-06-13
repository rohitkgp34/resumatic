#!/bin/bash
export FABRIC_CFG_PATH=${PWD}
# GIVE A CHANNEL NAME OF YOUR OWN CHOICE
export CHANNEL_NAME=mychannel 

# Generating crytographic material :- Certs
echo "=========================================="
echo "        Generating Certificates           "
echo "=========================================="
./cryptogen generate --config=./crypto-config.yaml

# Generating Orderer and Genesis block
echo "=========================================="
echo "     Creating Orderer Genesis Block       "
echo "=========================================="
mkdir channel-artifacts
chmod 777 *
# ./configtxgen -profile SampleDevModeKafka -channelID mychannel -outputBlock ./channel-artifacts/genesis.block
./configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block

# Creating a Channel Config Transaction
echo "=========================================="
echo "         Creating Channel Config          "
echo "=========================================="
./configtxgen -profile MyChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID $CHANNEL_NAME
# configtxgen -profile ${CHANNEL_PROFILE} -outputCreateChannelTx ./config/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME

# Defining Anchor peers from all organisations

echo "=========================================="
echo "          Defining Anchor Peers           "
echo "=========================================="
echo ""
echo ""
echo "Org1......."
./configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
echo "Org2......."
./configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
echo "Org3......."
./configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP
echo "Org4......."
./configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/Org4MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org4MSP
echo "Org5......."
./configtxgen -profile MyChannel -outputAnchorPeersUpdate ./channel-artifacts/Org5MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org5MSP

Setting up the network using docker compose
for i in {1..5}; do
     export BYFN_CA"${i}"_PRIVATE_KEY=$(ls crypto-config/peerOrganizations/org${i}.example.com/ca/ | grep _sk)
done
# echo "=========================================="
# echo "           Setting up Network             "
# echo "=========================================="
# export IMAGE_TAG=latest
# docker-compose -f docker-compose-cli.yaml up -d
# docker exec cli scripts/functions.sh