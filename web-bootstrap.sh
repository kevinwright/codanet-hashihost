#!/usr/bin/env bash

E_NOTROOT=87 # Non-root exit error.

if [ "${UID:-$(id -u)}" -ne 0 ]; then
  printf '\t Error: Please retry as the root user\n'
  exit $E_NOTROOT
fi

apt install -y git
git clone https://github.com/kevinwright/codanet-hashihost.git
cd codanet-hashihost/prepare
./prepare.sh