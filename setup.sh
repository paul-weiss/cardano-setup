#!/bin/bash

# vars
export CARDANO_VERSION="9.0.0"
export DB_SYNC_VERSION="13.3.0.0"
export DB_PASSWORD="changeme123!" # you should change this prior to running, todo: prompt for pwd

# setup dir structure
mkdir cardano
mkdir mainnet
mkdir mainnet/config

# download cardano binaries
cd cardano
wget https://github.com/IntersectMBO/cardano-node/releases/download/$CARDANO_VERSION/cardano-node-$CARDANO_VERSION-linux.tar.gz
tar -xvf cardano-node-$CARDANO_VERSION-linux.tar.gz

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

# Register cardano-node as a service
sudo tee /etc/systemd/system/cardano-node.service > /dev/null <<EOF
[Unit]
Description=Cardano Node
After=network.target

[Service]
User=ubuntu
Type=simple
WorkingDirectory=/home/ubuntu/mainnet
ExecStart=/usr/local/bin/cardano-node run \
--topology /home/ubuntu/mainnet/configs/topology.json \
--database-path /home/ubuntu/mainnet/db \
--socket-path /home/ubuntu/mainnet/node.socket \
--port 3434 \
--config /home/ubuntu/mainnet/configs/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable cardano-node.service
sudo systemctl start cardano-node.service

echo "Observe Cardano Node logs:"
echo "journalctl-fu cardano-node.service"

cd ~
git clone https://github.com/IntersectMBO/cardano-db-sync
cd cardano-db-sync
git checkout $DB_SYNC_VERSION

wget https://github.com/IntersectMBO/cardano-db-sync/releases/download/$DB_SYNC_VERSION/cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz
tar -xvf cardano-db-sync-$DB_SYNC_VERSION-linux.tar.gz

sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql.service
# Enter shell as default postgres user:
sudo -i -u postgres 
psql
CREATE USER ubuntu WITH PASSWORD '$DB_PASSWORD';
ALTER ROLE ubuntu WITH SUPERUSER;
ALTER ROLE ubuntu WITH CREATEDB;
CREATE DATABASE cexplorer;
exit
exit

# setup db-sync as a service
sudo tee /etc/systemd/system/cardano-db-sync.service > /dev/null <<EOF
[Unit]
Description=Cardano DB Sync Service
After=network.target

[Service]
Environment=PGPASSFILE=/home/ubuntu/cardano-db-sync/config/pgpass-mainnet
ExecStart=/usr/local/bin/cardano-db-sync --config /home/ubuntu/mainnet/configs/db-sync-config.json --socket-path /home/ubuntu/mainnet/node.socket --state-dir /home/ubuntu/mainnet/db-sync/ledger-state --schema-dir /home/ubuntu/cardano-db-sync/schema/
User=ubuntu
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload && \
sudo systemctl enable cardano-db-sync.service && \
sudo systemctl start cardano-db-sync.service


