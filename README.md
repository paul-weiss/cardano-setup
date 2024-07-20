 <img src="https://cardano.org/img/cardano-logo-blue.svg" width="400" height="100">

# Cardano Setup

### Assumptions
* running as user ubuntu on linux machine
* minimum hardware requirements met ([link](https://developers.cardano.org/docs/operate-a-stake-pool/hardware-requirements/))
* environment details source from ([here](https://book.world.dev.cardano.org/environments.html))
* Add the following to your `.bashrc`
```
if [ -f ~/cardano-setup/.cardano-setup ]; then
    source ~/cardano-setup/.cardano-setup
fi
```

### Download repo & set execute permissions
```
git clone https://github.com/paul-weiss/cardano-setup.git
cd cardano-setup
chmod +x *.sh
```

### `mainnet` setup
```
./setup.sh
```

### `preview` setup
```
./setup-preview.sh
```

### Verify services are running
* `journalctl -fu cardano-node.service`
* `journalctl -fu cardano-db-sync.service`
* `journalctl -fu ogmios.service`
* `journalctl -fu kupo.service`

### Dependencies
* [cardano-node](https://github.com/IntersectMBO/cardano-node)
* [cardano-db-sync](https://github.com/IntersectMBO/cardano-db-sync)
* [kupo](https://github.com/CardanoSolutions/kupo)
* [ogmios](https://github.com/cardanosolutions/ogmios)
