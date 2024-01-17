#!/usr/bin/env bash

systemctl status consul.service
systemctl status consul-template.service
systemctl status nomad.service
systemctl status vault.service

#journalctl -xeu consul.service
#journalctl -xeu consul-template.service
#journalctl -xeu nomad.service
#journalctl -xeu vault.service