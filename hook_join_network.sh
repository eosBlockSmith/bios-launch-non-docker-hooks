#!/bin/bash

# `join_network` hook:
# $1 = p2p_address
# $2 = public key for this node (the one you published in your discovery file)
# $3 = private key for this node (loaded from `block_signing_private_key_path`)
# $4 = genesis_json
# $5 = producer-name list (in case you've been cloned), like: "producer-name = hello\nproducer-name = hello.a"
# $6 = producer-name you should handle, split by comma

CONF=/etc/eosio
DATA=/var/lib

echo "Killing running nodes"
killall nodeos

echo "Removing old nodeos data (you might be asked for your sudo password)..."
sudo rm -rf /tmp/nodeos-data

echo "Writing genesis.json"
echo $4 > $CONF/$5/genesis.json

echo "Copying base config"
# Your base_config.ini shouldn't contain any `producer-name` nor `private-key` nor `enable-stale-production` statements.
cp base_config.ini $CONF/$5/config.ini
echo "p2p-peer-address = $1" >> $CONF/$5/config.ini
echo "$5" >> $CONF/$5/config.ini
echo "private-key = [\"$2\",\"$3\"]" >> $CONF/$5/config.ini

echo "Running 'nodeos' ."
nodeos --conf-dir $conf/$5 --data-dir $DATA/$5 &

echo "Waiting for nodeos to launch "
sleep 3
