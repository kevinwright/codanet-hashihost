#!/usr/bin/env bash

systemctl --no-pager stop vault.service
systemctl --no-pager stop nomad.service
systemctl --no-pager stop consul-template.service
systemctl --no-pager stop consul.service

#journalctl --no-pager -xeu consul.service
#journalctl --no-pager -xeu consul-template.service
#journalctl --no-pager -xeu nomad.service
#journalctl --no-pager -xeu vault.service