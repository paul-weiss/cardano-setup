#!/bin/bash
#====================================================================================================================================
# CARDANO SPO Setup for preview
#====================================================================================================================================

chmod +x installers.sh
. ./installers.sh

# vars
export CARDANO_VERSION="9.0.0"
export CARDANO_ENV="preview"
export DB_PASSWORD="preview123!"
export DB_SYNC_VERSION="13.3.0.0"
export KUPO_VERSION="2.9"
export KUPO_PATCH_VERSION="0"
export OGMIOS_VERSION="6.5.0"

# prerequisites
sudo apt-get install unzip

stop_services
install_postgresql
install_cardano_node $CARDANO_ENV $CARDANO_VERSION
install_cardano_db_sync $CARDANO_ENV $DB_SYNC_VERSION
install_ogmios $CARDANO_ENV $OGMIOS_VERSION
install_kupo $CARDANO_ENV $KUPO_VERSION $KUPO_PATCH_VERSION
