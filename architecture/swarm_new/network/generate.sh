#!/bin/bash

export PATH=$PATH:${PWD}/bin
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel
CHANNEL_PROFILE=MyChannel
ANCHOR_TX=MSPanchors_${CHANNEL_NAME}.tx

# remove previous crypto material and config transactions
rm -rf config
rm -rf crypto-config
mkdir config


cryptogen generate --config=./crypto-config.yaml
echo "\========================Generated new certs========================/"
echo


# generate genesis block for orderer
configtxgen -profile OrdererGenesis -outputBlock ./config/genesis.block -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
else
  echo "\=====================Generated Genesis block=====================/"
  echo
fi


# generate channel configuration transaction for mychannel
configtxgen -profile ${CHANNEL_PROFILE} -outputCreateChannelTx ./config/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
else
  echo "\=======================Channel Config Txn========================/"
  echo
fi

# generate anchor peer for mychannel as <org>, <org> in {1,2,3,4,5}
for org in {1..5}; do
  configtxgen -profile ${CHANNEL_PROFILE} -outputAnchorPeersUpdate ./config/ORG${org}${ANCHOR_TX} -channelID $CHANNEL_NAME -asOrg Org${org}MSP
  if [ "$?" -ne 0 ]; then
    echo "Failed to generate anchor peer update for Org${org}MSP..."
    exit 1
  else
    echo "\===============Anchor peer updated for Org${org}===============/"
    echo
  fi
done


