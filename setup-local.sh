#!/bin/bash
#====================================================================================================================================
# CARDANO SPO Setup for a private testnet
#====================================================================================================================================
. ./installers.sh

# vars
export CARDANO_VERSION="9.2.1"
export CARDANO_ENV="private"
export DB_PASSWORD="private123!" # you should change this prior to running, todo: prompt for pwd
export DB_SYNC_VERSION="13.5.0.2"
export KUPO_VERSION="2.9"
export KUPO_PATCH_VERSION="0"
export OGMIOS_VERSION="6.8.0"

# prerequisites
sudo apt-get install unzip

install_cardano_node $CARDANO_ENV $CARDANO_VERSION
#install_cardano_db_sync $CARDANO_ENV $DB_SYNC_VERSION $ROOT_DIR
#install_postgresql
#install_ogmios $CARDANO_ENV $OGMIOS_VERSION
#install_kupo $CARDANO_ENV $KUPO_VERSION $KUPO_PATCH_VERSION
