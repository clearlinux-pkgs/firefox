#!/bin/bash

VERSION=`curl -s http://ftp.mozilla.org/pub/firefox/releases/ | grep href | cut -f3 -d">" | cut -f1 -d"/" | cut -f1 -d"-" | grep -v "b" | sort -n | tail -1`


if [[ -z "${VERSION}" ]]; then
    echo "Unable to find version upstream."
    exit 1
fi

#no spaces in version we hope..
CURRENT_VERSION=$(grep "^Version" firefox.spec | cut -f4 -d" ")

if [[ v"${CURRENT_VERSION}" == v"${VERSION}" ]]; then
	exit 2
fi

sed firefox.spec.in -e "s/\#\#VERSION\#\#/${VERSION}/g" > firefox.spec
make generateupstream || exit 3

git add firefox.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"
make bump
