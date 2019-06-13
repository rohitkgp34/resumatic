# sudo mkdir -p /var/mynetwork
# sudo chown -R $(whoami) /var/mynetwork
# sudo chown -R $USER:$USER /var/mynetwork
rm -rf mkdir /var/mynetwork/*

mkdir -p /var/mynetwork/chaincode
mkdir -p /var/mynetwork/certs/scripts/
mkdir -p /var/mynetwork/bin
mkdir -p /var/mynetwork/fabric-src

git clone https://github.com/hyperledger/fabric /var/mynetwork/fabric-src/hyperledger/fabric
cd /var/mynetwork/fabric-src/hyperledger/fabric
# git checkout release-1.4
cd -
cp -R crypto-config /var/mynetwork/certs/
cp -R config /var/mynetwork/certs/
cp -R ../chaincodes/* /var/mynetwork/chaincode/
cp -R bin/* /var/mynetwork/bin/
cp -R tasks/* /var/mynetwork/certs/scripts/
echo "If prompted, please enter password to chown /var/mynetwork"
sudo chown -R $USER /var/mynetwork