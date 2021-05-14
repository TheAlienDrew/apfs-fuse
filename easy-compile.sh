#!/bin/bash

# install any requires packages first
required_packages=(fuse libfuse3-dev bzip2 libbz2-dev cmake gcc g++ libattr1-dev zlib1g-dev)
to_install=()
for package in "${required_packages[@]}"; do
  dpkg -L $package >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    to_install+=($package)
  fi
done
if [ -n "${to_install[*]}" ]; then
  echo "Some packages may be required to continue..."
  sudo apt-get install $to_install
fi

# continue with compilation
cd apfs-fuse
git submodule init
git submodule update
mkdir -p build
cd build
ccmake ..
make
