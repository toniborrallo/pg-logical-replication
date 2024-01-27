#!/bin/bash
source ./scripts/common


docker-compose up --build -d

# delay for starting up postgres containers
wait_dial 10

./scripts/create-publications.sh
./scripts/create-subscriptions.sh