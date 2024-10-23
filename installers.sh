#!/bin/bash

#====================================================================================================================================
# CARDANO NODE
# $1: environment (mainnet || preview)
# $2: version
#====================================================================================================================================
install_cardano_node() {
    sudo adduser cardano --system
    sudo rm -Rf /usr/local/cardano-node
    sudo rm -Rf /usr/local/etc/cardano-node
    sudo rm -Rf /var/lib/cardano-node
    sudo mkdir /usr/local/cardano-node
    sudo mkdir /usr/local/etc/cardano-node
    sudo mkdir /var/lib/cardano-node
    sudo mkdir /var/lib/cardano-node/db
    sudo mkdir /var/lib/cardano-node/$1
    sudo chmod -R 777 /var/lib/cardano-node
    sudo cp -r svc/ /usr/local/etc/cardano-node
    sudo mkdir /usr/local/etc/cardano-node/$1
    cd /usr/local/cardano-node
    sudo wget https://github.com/IntersectMBO/cardano-node/releases/download/$2/cardano-node-$2-linux.tar.gz
    sudo tar -xvf cardano-node-$2-linux.tar.gz
    sudo rm cardano-node-$2-linux.tar.gz
    
    # download mainnet configs
    cd /usr/local/etc/cardano-node/$1
    sudo wget https://book.world.dev.cardano.org/environments/$1/config.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/config-bp.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/db-sync-config.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/submit-api-config.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/topology.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/byron-genesis.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/shelley-genesis.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/alonzo-genesis.json
    sudo wget https://book.world.dev.cardano.org/environments/$1/conway-genesis.json
    
    # Register cardano-node as a service
    sudo systemctl stop cardano-node-$1.service
    sudo cp /usr/local/etc/cardano-node/svc/cardano-node-$1.service /etc/systemd/system/cardano-node-$1.service
    sudo systemctl daemon-reload && \
    sudo systemctl enable cardano-node-$1.service && \
    sudo systemctl start cardano-node-$1.service
}

#====================================================================================================================================
# CARDANO DB-SYNC 
# $1: environment (mainnet || preview)
# $2: version
#====================================================================================================================================
install_cardano_db_sync() {
    cd $3
    rm -Rf cardano-db-sync
    git clone https://github.com/IntersectMBO/cardano-db-sync
    # Checkout the version you will run:
    cd cardano-db-sync &&
    git checkout 13.3.0.0
    mkdir bin
    cd bin
    wget https://github.com/IntersectMBO/cardano-db-sync/releases/download/$2/cardano-db-sync-$2-linux.tar.gz
    tar -xvf cardano-db-sync-$2-linux.tar.gz
    rm cardano-db-sync-$2-linux.tar.gz
    
    # Register cardano-db-sync as a service
    sudo systemctl stop cardano-db-sync.service
    if [ "$1" = "mainnet" ]; then
        sudo cp ~/cardano-setup/svc/cardano-db-sync.service /etc/systemd/system/cardano-db-sync.service
    elif [ "$1" = "preview" ]; then
        sudo cp ~/cardano-setup/svc/cardano-db-sync.preview.service /etc/systemd/system/cardano-db-sync.service
    fi
    sudo systemctl daemon-reload && \
    sudo systemctl enable cardano-db-sync.service && \
    sudo systemctl start cardano-db-sync.service
}

#====================================================================================================================================
# POSTGRESQL
# same db for all environments
#====================================================================================================================================
install_postgresql() {
    sudo systemctl stop postgresql.service
    sudo apt remove -y postgresql
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl start postgresql.service
    sudo -u postgres psql -U postgres -f ~/cardano-setup/db/setup.sql
}

#====================================================================================================================================
# OGMIOS
# $1: environment (mainnet || preview)
# $2: version
#====================================================================================================================================
install_ogmios() {
    cd ~
    rm -Rf ogmios
    mkdir ogmios
    cd ogmios
    wget "https://github.com/CardanoSolutions/ogmios/releases/download/v$2/ogmios-v$2-x86_64-linux.zip"
    unzip "ogmios-v$2-x86_64-linux.zip"
    rm "ogmios-v$2-x86_64-linux.zip"
    chmod +x bin/ogmios
    
    # Register cardano-db-sync as a service
    sudo systemctl stop ogmios.service
    if [ "$1" = "mainnet" ]; then
        sudo cp ~/cardano-setup/svc/ogmios.service /etc/systemd/system/ogmios.service
    elif [ "$1" = "preview" ]; then
        sudo cp ~/cardano-setup/svc/ogmios.preview.service /etc/systemd/system/ogmios.service
    fi
    sudo systemctl daemon-reload && \
    sudo systemctl enable ogmios.service && \
    sudo systemctl start ogmios.service
}

#====================================================================================================================================
# KUPO
# $1: environment (mainnet || preview)
# $2: version expects X.X
# $3: patch version
#====================================================================================================================================
install_kupo() {
    cd ~
    rm -Rf kupo
    mkdir kupo
    cd kupo
    # version not easily put into var :(
    wget "https://github.com/CardanoSolutions/kupo/releases/download/v$2/kupo-v$2.$3-x86_64-linux.zip"
    unzip "kupo-v$2.$3-x86_64-linux.zip"
    rm "kupo-v$2.$3-x86_64-linux.zip"
    chmod +x bin/kupo
    
    # Register ogmios as a service
    sudo systemctl stop kupo.service
    if [ "$1" = "mainnet" ]; then
        sudo cp ~/cardano-setup/svc/kupo.service /etc/systemd/system/kupo.service
    elif [ "$1" = "preview" ]; then
        sudo cp ~/cardano-setup/svc/kupo.preview.service /etc/systemd/system/kupo.service
    fi
    sudo systemctl daemon-reload && \
    sudo systemctl enable kupo.service && \
    sudo systemctl start kupo.service
}

