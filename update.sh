#!/bin/bash

set -e
set -o pipefail

git pull
VERSION=$(curl -sSf http://ftp.mozilla.org/pub/firefox/releases/ | grep href | cut -f3 -d">" | cut -f1 -d"/" | grep -Ex '[0-9.]+' | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -1)

if [[ -z "${VERSION}" ]]; then
    echo "Unable to find version upstream."
    exit 1
fi

#no spaces in version we hope..
CURRENT_VERSION=$(grep "^Version" firefox.spec | cut -f4 -d" ")
CURRENT_RELEASE=$(grep "^Release" firefox.spec | cut -f4 -d" ")

if [[ v"${CURRENT_VERSION}" == v"${VERSION}" ]]; then
	exit 2
fi

sed -e "s/##VERSION##/${VERSION}/g; s/##RELEASE##/${CURRENT_RELEASE}/" firefox.spec.in > firefox.spec
make generateupstream || exit 3

make bumpnogit
git add firefox.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"
make koji
