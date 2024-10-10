# Local Cluster Setup

### Plutip Setup
* [Plutip Docs](https://github.com/mlabs-haskell/plutip/tree/master/local-cluster)
```bash
echo "install nix"
curl -L https://nixos.org/nix/install | sh -s -- --daemon
nix develop # go get a coffee
nix-env -iA nixpkgs.niv
niv init
niv add input-output-hk/haskell.nix -n haskellNix
```

### Updating version of haskellNix
```niv update haskellNix```


### Links

* [Cardano docs](https://docs.cardano.org/cardano-testnets/local-testnet/)
* [Nix install](https://nix.dev/install-nix)
