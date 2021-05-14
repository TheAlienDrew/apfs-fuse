#!/bin/bash

# Only continue if binary files are available
if [ ! -f build/apfs-fuse ] || [ ! -f build/apfsutil ]; then
  echo "Please compile first before trying to package to deb."
  exit 1
fi

read -p "Enter package name (characters allowed: a-z A-z 0-9 _ -): " package
read -p "Enter version (e.g. 1.0.0): " version
read -p "Enter revision (e.g. 1): " revision
read -p "Enter maintainer (name and email): " maintainer
read -p "Enter description (use \"\n \" for newlines): " description

fullpackage="${package}_${version}-${revision}"
mkdir -p "${fullpackage}"
mkdir -p "${fullpackage}/usr"
mkdir -p "${fullpackage}/usr/local"

installdir="${fullpackage}/usr/local/bin"
mkdir -p "${installdir}"

cp build/apfs-fuse "${installdir}"
cp build/apfsutil "${installdir}"

debiandir="${fullpackage}/DEBIAN"
debcontrol="${debiandir}/control"
mkdir -p "${fullpackage}/DEBIAN"
echo "Package: ${package}" > "${debcontrol}"
echo "Version: ${version}-${revision}" >> "${debcontrol}"
echo "Section: base" >> "${debcontrol}"
echo "Priority: optional" >> "${debcontrol}"
echo "Architecture: amd64" >> "${debcontrol}"
echo "Depends: fuse, bzip2" >> "${debcontrol}"
echo "Maintainer: ${maintainer}" >> "${debcontrol}"
echo -e "Description: ${description}" >> "${debcontrol}"

dpkg-deb --build "${fullpackage}"
chmod +x "${fullpackage}.deb"
