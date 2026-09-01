#!/bin/bash

if [[ -f ./consts.sh ]]; then
    source ./consts.sh
else
    echo "Error: consts.sh not found. Please make sure to run the setup first." >&2
    exit 1
fi

echo "Building for Windows ..."

GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-s -w" -tags selfupdate,disable_grpc_modules -o restic_windows_amd64.exe ./cmd/restic

echo "Success. Built for Windows."
