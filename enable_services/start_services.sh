#!/usr/bin/env bash

systemctl --no-pager start consul.service
systemctl --no-pager start consul-template.service
systemctl --no-pager start nomad.service
systemctl --no-pager start vault.service

