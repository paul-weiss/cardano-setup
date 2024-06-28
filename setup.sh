#!/bin/bash

## todo:
## add params for different os, and cardano versions

mkdir cardano
mkdir mainnet
mkdir mainnet/config
cd cardano
wget https://github.com/IntersectMBO/cardano-node/releases/download/8.9.3/cardano-node-8.9.3-linux.tar.gz
tar -xvf cardano-node-8.9.3-linux.tar.gz

echo "export PATH=$(pwd)/cardano/bin:$PATH" >> ~/.bashrc
echo "export CARDANO_NODE_SOCKET_PATH=$(pwd)/mainnet/node.socket" >> ~/.bashrc

