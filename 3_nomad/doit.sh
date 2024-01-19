#!/usr/bin/env bash

full_script_path=$(readlink -f ${BASH_SOURCE[0]})
script_dir=$(dirname ${full_script_path})

export hostname=$(hostname -s)
source $script_dir/../util/determine_networks.sh


case $(uname) in 
  Darwin)
    export conf_dir="/tmp/nomad.d"
    mkdir -p ${conf_dir}
    ;;
  Linux)
    export conf_dir="/etc/nomad.d"
    mkdir -p ${conf_dir}
    mkdir -p /var/hcp/nomad/data
    chown --recursive nomad:nomad /var/hcp/nomad
    ;;
esac

systemctl stop nomad.service
cat "$script_dir/nomad.d/nomad.hcl" | envsubst > ${conf_dir}/nomad.hcl
systemctl --no-pager start nomad.service
sleep 2
systemctl --no-pager status nomad.service
nomad status