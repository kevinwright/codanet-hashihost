#!/usr/bin/env bash

systemctl --no-pager status consul.service
systemctl --no-pager status consul-template.service
systemctl --no-pager status nomad.service
systemctl --no-pager status vault.service

#journalctl --no-pager -xeu consul.service
#journalctl --no-pager -xeu consul-template.service
#journalctl --no-pager -xeu nomad.service
#journalctl --no-pager -xeu vault.service