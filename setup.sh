#!/bin/bash
#====================================================================================================================================
# CARDANO SPO Setup for mainnet
#====================================================================================================================================

# vars
export CARDANO_VERSION="9.0.0"
export DB_SYNC_VERSION="13.3.0.0"
export OGMIOS_VERSION="6.5.0"
export DB_PASSWORD="changeme123!" # you should change this prior to running, todo: prompt for pwd
export CARDANO_ENV="mainnet"

# prerequisites
sudo apt-get install unzip

# setup dir structure
cd ~
mkdir cardano
mkdir mainnet
mkdir mainnet/config
mkdir kupo
mkdir ogmios

#====================================================================================================================================
# CARDANO NODE
#====================================================================================================================================
cd cardano
wget https://github.com/IntersectMBO/cardano-node/releases/download/$CARDANO_VERSION/cardano-node-$CARDANO_VERSION-linux.tar.gz
tar -xvf cardano-node-$CARDANO_VERSION-linux.tar.gz
rm cardano-node-$CARDANO_VERSION-linux.tar.gz

# download mainnet configs
cd ../$CARDANO_ENV/config
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/config.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/config-bp.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/db-sync-config.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/submit-api-config.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/topology.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/byron-genesis.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/shelley-genesis.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/alonzo-genesis.json
wget https://book.world.dev.cardano.org/environments/$CARDANO_ENV/conway-genesis.json

# Register cardano-node as a service
sudo cp ~/cardano-setup/svc/cardano-node.service /etc/systemd/system/cardano-node.service
sudo systemctl daemon-reload && \
sudo systemctl enable cardano-node.service && \
sudo systemctl start cardano-node.service

#====================================================================================================================================
# CARDANO DB-SYNC
#====================================================================================================================================
cd ~
git clone https://github.com/IntersectMBO/cardano-db-sync
# Checkout the version you will run:
cd cardano-db-sync &&
git checkout 13.3.0.0
mkdir bin
cd bin
wget https://github.com/IntersectMBO/cardano-db-sync/releases/download/$DB_SYNC_VERSION/cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz
tar -xvf cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz
rm cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz

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
rm ogmios-v$OGMIOS_VERSION-x86_64-linux.zip
chmod +x bin/ogmios

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
rm kupo-2.8.0-amd64-Linux.tar.gz
chmod +x bin/kupo

# Register ogmios as a service
sudo cp ~/cardano-setup/svc/kupo.service /etc/systemd/system/kupo.service
sudo systemctl daemon-reload && \
sudo systemctl enable kupo.service && \
sudo systemctl start kupo.service

