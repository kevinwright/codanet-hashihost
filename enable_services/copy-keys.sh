#!/usr/bin/env bash

# sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
scp keys.gitignore.auto.tfvars root@cvnt-1:/root/codanet-hashihost/enable_services
scp keys.gitignore.auto.tfvars root@cvnt-2:/root/codanet-hashihost/enable_services
scp keys.gitignore.auto.tfvars root@cvnt-3:/root/codanet-hashihost/enable_services
