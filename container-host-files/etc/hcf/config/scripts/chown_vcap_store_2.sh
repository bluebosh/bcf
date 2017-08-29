#!/bin/sh
mkdir -p /var/vcap/store
exec chown vcap:vcap /var/vcap/store
