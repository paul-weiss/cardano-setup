# Cardano Setup for `mainnet`

### Assumptions
* running as user ubuntu on linux machine
* minimum hardware requirements met ([link](https://developers.cardano.org/docs/operate-a-stake-pool/hardware-requirements/))
* you want to connect to `mainnet`

### Download repo
* `git clone https://github.com/paul-weiss/cardano-setup.git`
* `cd cardano-setup`
* `chmod +x setup.sh`
* `./setup.sh`

### Verify services are running
* `journalctl -fu cardano-node.service`
* `journalctl -fu cardano-db-sync.service`
* `journalctl -fu ogmios.service`
* `journalctl -fu kupo.service`
