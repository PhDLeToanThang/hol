#!/usr/bin/env bash
cd /opt
git clone https://github.com/ishare2-org/ishare2-cli.git
cd ishare2-cli
cp ishare2 /usr/sbin/
chmod +x /usr/sbin/ishare2
ishare2
