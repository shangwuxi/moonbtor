#!/usr/bin/env bash
# Pin the official installer script and the stable compiler/core release together.
set -euo pipefail
if [[ $# != 1 || -z "$1" || -e "$1" ]]; then
  echo 'usage: install-toolchain.sh NEW_DIRECTORY' >&2
  exit 2
fi
dest="$1"
version='0.10.19+97801ee1b'
installer_sha='46495f8cdc0050f79b6cb195d66478d101cb3601d68506568fbe377fcdf2a9fe'
downloads="$(mktemp -d)"
trap 'rm -rf -- "$downloads"' EXIT
curl --fail --location --retry 2 --connect-timeout 20 --max-time 60 \
  'https://cli.moonbitlang.com/install/unix.sh' -o "$downloads/install.sh"
printf '%s  %s\n' "$installer_sha" "$downloads/install.sh" | sha256sum --check
MOON_HOME="$dest" bash "$downloads/install.sh" "$version"
export MOON_HOME="$dest"
export MOON_TOOLCHAIN_ROOT="$dest"
export PATH="$dest/bin:$PATH"
moon version --all
moonc -v | grep -F "v$version"
