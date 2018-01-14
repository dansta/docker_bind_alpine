#!/bin/bash
set -x

/usr/bin/wget --no-check-certificate -O BIND_ROOT_SERVERS https://www.internic.net/domain/named.cache
/usr/sbin/named -4 -n 4 -U 4 -p BIND_PORT -u BIND_EFFECTIVE_USER -c BIND_CONF -d2
