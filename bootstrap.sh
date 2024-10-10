#!/bin/bash

sudo apt-get update -y

# prerequisites for Cardano
sudo apt-get install automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw6 libtool autoconf liblmdb-dev -y

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

sudo apt install gcc
sudo apt install -y protobuf-compiler
sudo apt install clang

ghcup install ghc 8.10.7
ghcup install cabal 3.8.1.0
ghcup set ghc 8.10.7
ghcup set cabal 3.8.1.0
