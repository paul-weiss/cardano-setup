#!/bin/bash

## todo:
## add params for different os, and cardano versions

# setup dir structure
mkdir cardano
mkdir mainnet
mkdir mainnet/config

# download cardano binaries
cd cardano
wget https://github.com/IntersectMBO/cardano-node/releases/download/8.9.3/cardano-node-8.9.3-linux.tar.gz
tar -xvf cardano-node-8.9.3-linux.tar.gz

# setup path vars
echo "export PATH=$(pwd)/bin:$PATH" >> ~/.bashrc
echo "export CARDANO_NODE_SOCKET_PATH=$(pwd)/mainnet/node.socket" >> ~/.bashrc

# download configs
cd ../mainnet/config
wget https://book.world.dev.cardano.org/environments/mainnet/config.json
wget https://book.play.dev.cardano.org/environments/mainnet/db-sync-config.json
wget https://book.play.dev.cardano.org/environments/mainnet/submit-api-config.json
wget https://book.play.dev.cardano.org/environments/mainnet/topology.json
wget https://book.play.dev.cardano.org/environments/mainnet/byron-genesis.json
wget https://book.play.dev.cardano.org/environments/mainnet/shelley-genesis.json
wget https://book.play.dev.cardano.org/environments/mainnet/alonzo-genesis.json
wget https://book.world.dev.cardano.org/environments/mainnet/conway-genesis.json


