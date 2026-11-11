#!/usr/bin/env bash
# Official Linux x86_64 archives; compiler and core pinned together.
set -euo pipefail
if [[ $# != 1 || -z "$1" || -e "$1" ]]; then
  echo 'usage: install-toolchain.sh NEW_DIRECTORY' >&2
  exit 2
fi
dest="$1"
mkdir -p "$dest/lib"
downloads="$(mktemp -d)"
trap 'rm -rf -- "$downloads"' EXIT
curl --fail --location --retry 2 --connect-timeout 20 --max-time 300 \
  'https://cli.moonbitlang.com/binaries/0.10.18%2B6c83a7f62/moonbit-linux-x86_64.tar.gz' -o "$downloads/toolchain.tar.gz"
curl --fail --location --retry 2 --connect-timeout 20 --max-time 120 \
  'https://cli.moonbitlang.com/cores/core-0.10.18%2B6c83a7f62.tar.gz' -o "$downloads/core.tar.gz"
(cd "$downloads" && printf '%s\n' \
  '0e4cde1ace98e8ef00552a937738b59c6901c4b8a004ebad71ea0e63688f63f1  toolchain.tar.gz' \
  '30a8ae1c1e1e8fde478ea742cbc928c8f4ae1f5c00090afe3f10c97be9e5da64  core.tar.gz' | sha256sum --check)
tar -xzf "$downloads/toolchain.tar.gz" -C "$dest"
tar -xzf "$downloads/core.tar.gz" -C "$dest/lib"
find "$dest/bin" -type f -exec chmod u+x {} +
export MOON_HOME="$dest"
export MOON_TOOLCHAIN_ROOT="$dest"
export PATH="$dest/bin:$PATH"
moon version --all
moonc -v | grep -F 'v0.10.18+6c83a7f62'
moon -C "$dest/lib/core" bundle --all --warn-list -a
