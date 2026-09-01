#!/bin/bash

set -e

GO_VERSION='1.26.4'
RESTIC_VERSION='0.19.1'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

USR_LOCAL_DIR="/usr/local"
RESTIC_SUB_DIR="restic-v$RESTIC_VERSION"
RESTIC_DIR="$USR_LOCAL_DIR/$RESTIC_SUB_DIR"
GO_SUB_DIR="go-v$GO_VERSION"
GO_DIR="$USR_LOCAL_DIR/$GO_SUB_DIR"

echo "Script from: https://github.com/m-primo/restic-patches"
echo "Following guide: https://restic.readthedocs.io/en/v0.19.1/developer_information.html#reproducible-builds (https://archive.ph/xezkk)"
echo "!!! This will force remove $GO_DIR & $RESTIC_DIR directories, and override \$GOPATH environment variable (for this script scope only); in order to have a clean setup !!!"

read -p "Do you want to continue? (y/N) " continue_1_answer
if [[ ! $continue_1_answer =~ ^[Yy]$ ]]; then
    echo "You did not accept to continue, exiting ..."
    exit 0
fi

echo "Downloading GO version: $GO_VERSION in $GO_DIR ..."
rm -rf $GO_DIR
mkdir -p $GO_DIR
cd $GO_DIR
curl -L "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz" | tar xz

export PATH="$GO_DIR/go/bin:$PATH"
export GOPATH="/var/local/go-v$GO_VERSION-build"

go version

echo "Downloading restic source code version: $RESTIC_VERSION in $RESTIC_DIR ..."
rm -rf $RESTIC_DIR
mkdir -p $RESTIC_DIR
cd $RESTIC_DIR
TZ=Europe/Berlin curl -L "https://github.com/restic/restic/releases/download/v$RESTIC_VERSION/restic-$RESTIC_VERSION.tar.gz" | tar xz --strip-components=1

echo "Applying the patches ..."
cd $SCRIPT_DIR
cp ./index-max-age.2026-08-28.patch $RESTIC_DIR
cd $RESTIC_DIR
patch -p0 --ignore-whitespace --verbose < index-max-age.2026-08-28.patch

echo "Finalizing ..."
cd $SCRIPT_DIR
cat > ./consts.sh <<EOF
export PATH="${GO_DIR}/go/bin:\$PATH"
export GOPATH="/var/local/go-v${GO_VERSION}-build"
EOF

chmod +x ./consts.sh
chmod +x ./build-linux.sh
chmod +x ./build-windows.sh

cp ./consts.sh $RESTIC_DIR
cp ./build-linux.sh $RESTIC_DIR
cp ./build-windows.sh $RESTIC_DIR

cd $RESTIC_DIR

echo "Setup should be successfull! You can now build using the build scripts: "
echo "cd $RESTIC_DIR && ./build-linux.sh and/or ./build-windows.sh"
