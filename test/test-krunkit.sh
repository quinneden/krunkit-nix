#!/usr/bin/env bash

basedir=$(dirname "$0")

if [[ ! -e $basedir/nixos.img ]]; then
  echo "error: no disk image found" >&2
  exit 1
fi

nix shell .#krunkit --command krunkit \
  --cpus 8 \
  --memory 8192 \
  --device "virtio-blk,path=$basedir/nixos.img"
