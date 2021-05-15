#!/bin/bash

# install any requires packages first
required_packages=(cmake gcc g++ fuse libfuse-dev bzip2 libbz2-dev libattr1-dev zlib1g-dev libicu-dev)
to_install=()
for package in "${required_packages[@]}"; do
  dpkg -L $package >/dev/null 2>&1
  if [ $? -eq 1 ]; then
    to_install+=($package)
  fi
done
if [ -n "${to_install[*]}" ]; then
  echo "Some packages may be required to continue..."
  sudo apt-get install ${to_install[*]}
fi

# continue with compilation
git submodule init
git submodule update
mkdir -p build
cd build
# need to disable FUSE3 since Ubuntu 18.04 doesn't have the libraries in the repo
cmake -DUSE_FUSE3=OFF ..
make
