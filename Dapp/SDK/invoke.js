/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');

const ccpPath = 'SDK/connection-org1.json';

async function main() {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join('SDK', 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        // console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user');
        if (!userExists) {
            console.log('An identity for the user "user" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'user', discovery: { enabled: true, asLocalhost: false } });
        // const userIdentity = gateway.getClient();
        // console.log(userIdentity)
        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        // console.log(network)
        // console.log(network)
        // Get the contract from the network.
        const contract = network.getContract('simple');
        contract.channel._last_refresh_request.target._grpc_wait_for_ready_timeout = 396000;
        // console.log(contract)
        // Submit the specified transaction.
        // createCar transaction - requires 5 argument, ex: ('createCar', 'CAR12', 'Honda', 'Accord', 'Black', 'Tom')
        // changeCarOwner transaction - requires 2 args , ex: ('changeCarOwner', 'CAR10', 'Dave')
        await contract.submitTransaction(...process.argv.slice(2));
        console.log('Transaction has been submitted');

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
}

main();