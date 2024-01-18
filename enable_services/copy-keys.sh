#!/usr/bin/env bash

# sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
scp keys.gitignore.auto.tfvars root@lxc-test-1:/root/codanet-hashihost/enable_services
scp keys.gitignore.auto.tfvars root@lxc-test-2:/root/codanet-hashihost/enable_services
scp keys.gitignore.auto.tfvars root@lxc-test-3:/root/codanet-hashihost/enable_services
