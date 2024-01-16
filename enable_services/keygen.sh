#!/usr/bin/env bash

gossip_key=$(consul keygen)
consul_token=$(uuidgen)

printf "gossip_key=\"$gossip_key\"\n" > keys.gitignore.auto.tfvars
printf "consul_token=\"$consul_token\"\n" >> keys.gitignore.auto.tfvars
echo "" >> keys.gitignore.auto.tfvars