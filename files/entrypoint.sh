#!/bin/sh
ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa -C "anonymous@domain.tld"

exec "$@"