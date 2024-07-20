#!/bin/bash
#====================================================================================================================================
# CARDANO SPO Setup for mainnet
#====================================================================================================================================

# vars
export CARDANO_VERSION="9.0.0"
export DB_SYNC_VERSION="13.3.0.0"
export OGMIOS_VERSION="6.5.0"
export DB_PASSWORD="changeme123!" # you should change this prior to running, todo: prompt for pwd

# prerequisites
sudo apt-get install unzip

# setup dir structure
cd ~
mkdir cardano
mkdir preview
mkdir preview/config
mkdir cardano-db-sync
mkdir kupo
mkdir ogmios

#====================================================================================================================================
# CARDANO NODE
#====================================================================================================================================
cd cardano
wget https://github.com/IntersectMBO/cardano-node/releases/download/$CARDANO_VERSION/cardano-node-$CARDANO_VERSION-linux.tar.gz
tar -xvf cardano-node-$CARDANO_VERSION-linux.tar.gz

# setup path vars
echo "export PATH=$(pwd)/bin:$PATH" >> ~/.bashrc
echo "export CARDANO_NODE_SOCKET_PATH=$(pwd)/mainnet/node.socket" >> ~/.bashrc

# download mainnet configs
cd ../preview/config
wget https://book.world.dev.cardano.org/environments/preview/config.json
wget https://book.world.dev.cardano.org/environments/preview/config-bp.json
wget https://book.world.dev.cardano.org/environments/preview/db-sync-config.json
wget https://book.world.dev.cardano.org/environments/preview/submit-api-config.json
wget https://book.world.dev.cardano.org/environments/preview/topology.json
wget https://book.world.dev.cardano.org/environments/preview/byron-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/shelley-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/alonzo-genesis.json
wget https://book.world.dev.cardano.org/environments/preview/conway-genesis.json

# Register cardano-node as a service
sudo cp ~/cardano-setup/svc/cardano-node.service /etc/systemd/system/cardano-node.service
sudo systemctl daemon-reload && \
sudo systemctl enable cardano-node.service && \
sudo systemctl start cardano-node.service

#====================================================================================================================================
# CARDANO DB-SYNC
#====================================================================================================================================
cd ~
cd cardano-db-sync
wget https://github.com/IntersectMBO/cardano-db-sync/releases/download/$DB_SYNC_VERSION/cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz
tar -xvf cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz

# Register cardano-db-sync as a service
sudo cp ~/cardano-setup/svc/cardano-db-sync.service /etc/systemd/system/cardano-db-sync.service
sudo systemctl daemon-reload && \
sudo systemctl enable cardano-db-sync.service && \
sudo systemctl start cardano-db-sync.service

#====================================================================================================================================
# POSTGRESQL
#====================================================================================================================================
# postgresql
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
# Enter shell as default postgres user:
sudo -u postgres psql -U postgres -f ~/cardano-setup/db/setup.sql

#====================================================================================================================================
# OGMIOS
#====================================================================================================================================
cd ~
cd ogmios
wget https://github.com/CardanoSolutions/ogmios/releases/download/v$OGMIOS_VERSION/ogmios-v$OGMIOS_VERSION-x86_64-linux.zip
unzip ogmios-v$OGMIOS_VERSION-x86_64-linux.zip

# Register cardano-db-sync as a service
sudo cp ~/cardano-setup/svc/ogmios.service /etc/systemd/system/ogmios.service
sudo systemctl daemon-reload && \
sudo systemctl enable ogmios.service && \
sudo systemctl start ogmios.service

#====================================================================================================================================
# KUPO
#====================================================================================================================================
cd ~
cd kupo
# version not easily put into var :(
wget https://github.com/CardanoSolutions/kupo/releases/download/v2.8/kupo-2.8.0-amd64-Linux.tar.gz
tar -xvf kupo-2.8.0-amd64-Linux.tar.gz

# Register ogmios as a service
sudo cp ~/cardano-setup/svc/kupo.service /etc/systemd/system/kupo.service
sudo systemctl daemon-reload && \
sudo systemctl enable kupo.service && \
sudo systemctl start kupo.service
