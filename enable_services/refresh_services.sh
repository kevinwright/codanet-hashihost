#!/usr/bin/env bash

./stop_services.sh
cd ../prepare
./refresh_services
cd ../enable_services
./start_services.sh
