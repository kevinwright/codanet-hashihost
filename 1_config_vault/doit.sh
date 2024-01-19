#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})

export hostname=$(hostname -s)
source $script_dir/../util/determine_networks.sh

# mkdir -p /etc/vault.d
# mkdir -p /var/hcp/vault/data
# chown --recursive vault:vault /var/hcp/vault
case $(uname) in 
  Darwin)
    export conf_dir="/tmp/vault.d"
    ;;
  Linux)
    export conf_dir="/etc/vault.d"
    ;;
esac

systemctl stop vault.service
cat "$script_dir/vault.hcl.template" | envsubst > ${conf_dir}/vault.hcl
systemctl start vault.service