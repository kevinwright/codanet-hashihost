#!/usr/bin/env bash

systemctl start consul.service
systemctl start consul-template.service
systemctl start nomad.service
systemctl start vault.service