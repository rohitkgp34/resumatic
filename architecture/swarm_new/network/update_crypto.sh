#!/bin/bash

# this moves the newly generated certs at C at the cli volume
export ORG=6
cp -R org${ORG}/crypto-config/peerOrganizations/org${ORG}.example.com \
 /var/mynetwork/certs/crypto-config/peerOrganizations