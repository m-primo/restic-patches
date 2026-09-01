#!/bin/bash

if [[ -f ./consts.sh ]]; then
    source ./consts.sh
else
    echo "Error: consts.sh not found. Please make sure to run the setup first." >&2
    exit 1
fi

echo "Building for Linux..."

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-s -w" -tags selfupdate,disable_grpc_modules -o restic_linux_amd64 ./cmd/restic

echo "Success. Built for Linux"
