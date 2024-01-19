#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})

export hostname=$(hostname -s)
source $script_dir/../util/determine_networks.sh


case $(uname) in 
  Darwin)
    export conf_dir="/tmp/vault.d"
    mkdir -p ${conf_dir}
    ;;
  Linux)
    export conf_dir="/etc/vault.d"
    mkdir -p ${conf_dir}
    mkdir -p /var/hcp/vault/data
    chown --recursive vault:vault /var/hcp/vault
    ;;
esac

systemctl stop vault.service
cat "$script_dir/vault.d/vault.hcl.template" | envsubst > ${conf_dir}/vault.hcl
systemctl --no-pager start vault.service
systemctl --no-pager status vault.service