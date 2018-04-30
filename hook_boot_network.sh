#!/bin/bash

# `boot_network` hook
# $1 genesis JSON
# $2 ephemeral public key
# $3 ephemeral private key
#
# This process must not BLOCK.
CONF=/etc/eosio
DATA=/var/lib

echo "Killing running nodes"
killall nodeos

echo "Phasing out any previous blockchain from disk"
mkdir -p $DATA/eos-bios
rm -rf $DATA/eos-bios/blocks $DATA/eos-bios/shared_mem

mkdir -p $CONF/eos-bios
echo "Copying base config"
cp base_config.ini $CONF/eos-bios/config.ini

echo "Writing genesis.json"
cp genesis.json $CONF/eos-bios/genesis.json

echo "producer-name = eosio" >> $CONF/eos-bios/config.ini
echo "enable-stale-production = true" >> $CONF/eos-bios/config.ini
echo "private-key = [\"$2\",\"$3\"]" >> $CONF/eos-bios/config.ini

echo "Removing old nodeos data (you might be asked for your sudo password)..."
sudo rm -rf /tmp/nodeos-data

echo "Running 'nodeos' "
nodeos --data-dir $DATA/eos-bios --config-dir $CONF/eos-bios  &
echo "Waiting for nodeos to launch "
sleep 3
