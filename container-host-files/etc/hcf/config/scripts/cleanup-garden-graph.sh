#!/bin/bash
set -o errexit -o nounset -o xtrace

mkdir -p /var/vcap/data/garden
mkdir -p /var/vcap/data/grootfs

rm -rf /var/vcap/data/garden/*
rm -rf /var/vcap/data/grootfs/*

# Ensure that runc and container processes can stat everything
chmod ugo+rx /var/vcap/data/garden
chmod ugo+rx /var/vcap/data/grootfs

