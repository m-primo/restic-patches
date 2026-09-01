# About this repository

This repository is for some [`restic`](https://github.com/restic/restic) (the backup tool) patches made by me to match some of my use cases.

# A patch for restic version 0.19.1

This patch reduces the index and blobs max age; as an attempt to allow restic to make more checkpoints during an upload/backup, so when an upload is interrupted/canceled it can resume where it stopped without reuploading the same uploaded files/packs again, to save bandwidth for those with limited internet. (You definitely will never notice any difference -or benefit- if you have a very high speed internet, and/or unlimited internet -or extremely high bandwidth- making this script useless for you)

I made this patch for myself and I'm still trying it out on my home internet and personal repository, I do not recommend that you use it unless you know what reduced index and blobs max ages do. *(I do NOT take any responsibility for any corrupted repository, altho this shouldn't corrupt or do any damage for repositories at all)*

Please check the [patch file](./index-max-age.2026-08-28.patch) to see the changes.

I followed [this guide](https://restic.readthedocs.io/en/v0.19.1/developer_information.html#reproducible-builds) ([archived version](https://archive.ph/xezkk)) to make the setup and build scripts.

If you're going to use this patch, please check all files yourself and review them.

## Note

The scripts were made to run on Linux, however you can simply adjust the setup script on Windows or any other OS (it's simple).

## Walkthrough

The setup script will:

1. Download `Go` version `1.26.4` into `/usr/local/go-v1.26.4` (if this directory already exist in your system it will force remove it first before downloading).
2. Extend the `$PATH` to include `/usr/local/go-v1.26.4/go/bin`.
3. Set the `$GOPATH` to `/var/local/go-v1.26.4-build` (if it already exist it will override it temporarily for the script scope only -this won't affect other tools/systems using this go path-).
4. Download the `restic` source code version `0.19.1` into `/usr/local/restic-v0.19.1` (if this directory already exist in your system it will force remove it first before downloading).
5. Copy and apply the patch file into the restic source code directory.

The build commands will simply run the `go build` command with specific flags.

## Prerequisites

This script assumes that you have the following tools installed:

(they should be available in most systems)

- [`curl`](https://en.wikipedia.org/wiki/CURL)
- [`patch`](https://en.wikipedia.org/wiki/Patch_(Unix))

Please kindly make sure you have them first before running the script; to avoid fatal errors (`which curl; which patch`).

## Run

First, download this repo whether by the download feature in GitHub or a `git clone`.

Make sure that the current working directory is in here before running the setup script.

### Setup

```bash
chmod +x ./setup.sh
./setup.sh
```

### Build

After a successful setup, you can now run the build script for your OS:

Windows:

```bash
./build-windows.sh
```

Linux:

```bash
./build-linux.sh
```

You should always build for Linux to test it out by simply running some restic command like `./restic_linux_amd64 version`.

The build commands will result in two files (self-contained binaries):

```plain
restic_linux_amd64
restic_windows_amd64.exe
```
