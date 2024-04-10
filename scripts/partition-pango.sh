#!/usr/bin/env bash

parted /dev/nvme0n1 -- mktable gpt
parted /dev/nvme0n1 -- mkpart fat32 1M 512M
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart linux 512M 100%
