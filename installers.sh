#!/bin/bash

#====================================================================================================================================
# CARDANO NODE
# $1: environment (mainnet || preview)
# $2: version
#====================================================================================================================================
install_cardano_node() {
    cd ~
    rm -Rf cardano
    rm -Rf $1
    mkdir cardano
    mkdir $1
    mkdir $1/config
    cd cardano
    wget https://github.com/IntersectMBO/cardano-node/releases/download/$2/cardano-node-$2-linux.tar.gz
    tar -xvf cardano-node-$2-linux.tar.gz
    rm cardano-node-$2-linux.tar.gz
    
    # download mainnet configs
    cd ../$1/config
    wget https://book.world.dev.cardano.org/environments/$1/config.json
    wget https://book.world.dev.cardano.org/environments/$1/config-bp.json
    wget https://book.world.dev.cardano.org/environments/$1/db-sync-config.json
    wget https://book.world.dev.cardano.org/environments/$1/submit-api-config.json
    wget https://book.world.dev.cardano.org/environments/$1/topology.json
    wget https://book.world.dev.cardano.org/environments/$1/byron-genesis.json
    wget https://book.world.dev.cardano.org/environments/$1/shelley-genesis.json
    wget https://book.world.dev.cardano.org/environments/$1/alonzo-genesis.json
    wget https://book.world.dev.cardano.org/environments/$1/conway-genesis.json
    
    # Register cardano-node as a service
    sudo systemctl stop cardano-node.service
    if [ "$1" = "mainnet" ]; then
        sudo cp ~/cardano-setup/svc/cardano-node.service /etc/systemd/system/cardano-node.service
    elif [ "$1" = "preview" ]; then
        sudo cp ~/cardano-setup/svc/cardano-node.preview.service /etc/systemd/system/cardano-node.service
    fi
    sudo systemctl daemon-reload && \
    sudo systemctl enable cardano-node.service && \
    sudo systemctl start cardano-node.service
}

#====================================================================================================================================
# CARDANO DB-SYNC 
# $1: environment (mainnet || preview)
# $2: version
#====================================================================================================================================
install_cardano_db_sync() {
    cd ~
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
    sudo apt install postgresql postgresql-contrib
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
    wget https://github.com/CardanoSolutions/ogmios/releases/download/v$2/ogmios-v$2-x86_64-linux.zip
    unzip ogmios-v$2-x86_64-linux.zip
    rm ogmios-v$2-x86_64-linux.zip
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
    wget https://github.com/CardanoSolutions/kupo/releases/download/v$2/kupo-$2.$3-amd64-Linux.tar.gz
    tar -xvf kupo-$2.$3-amd64-Linux.tar.gz
    rm kupo-$2.$3-amd64-Linux.tar.gz
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

stop_services() {
    sudo systemctl stop cardano-node.service
    sudo systemctl stop cardano-db-sync.service
    sudo systemctl stop kupo.service
    sudo systemctl stop ogmios.service
    sudo systemctl stop postgresql.service
}
