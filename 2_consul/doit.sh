#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})

export hostname=$(hostname -s)
source $script_dir/../util/determine_networks.sh


case $(uname) in 
  Darwin)
    export conf_dir="/tmp/consul.d"
    mkdir -p ${conf_dir}
    ;;
  Linux)
    export conf_dir="/etc/consul.d"
    mkdir -p ${conf_dir}
    mkdir -p /var/hcp/consul/data
    chown --recursive consul:consul /var/hcp/consul
    ;;
esac

systemctl stop consul.service
cat "$script_dir/consul.d/consul.hcl" | envsubst > ${conf_dir}/consul.hcl
systemctl --no-pager start consul.service
sleep 2
systemctl --no-pager status consul.service
consul members