#!/bin/bash

set -e
set -o pipefail

PKG=firefox

git pull --ff-only
# The `sed ... | sort --version-sort | sed ...` part of the pipeline forces
# beta releases sort correctly, leveraging the fact that the tilde character
# sorts before any other character.
VERSION=$(curl -sSf https://archive.mozilla.org/pub/firefox/releases/ \
	    | grep href \
	    | cut -f3 -d">" \
	    | cut -f1 -d"/" \
	    | sed 's/b/~/' \
	    | sort --version-sort \
	    | sed 's/~/b/' \
	    | grep -Ex '[0-9b.]+' \
	    | tail -1)

if [[ -z "${VERSION}" ]]; then
    echo "Unable to find version upstream."
    exit 1
fi

CURRENT_VERSION=$(grep "^Version" $PKG.spec | awk '{ print $3 }')
CURRENT_RELEASE=$(grep "^Release" $PKG.spec | awk '{ print $3 }')

if [[ v"${CURRENT_VERSION}" == v"${VERSION}" ]]; then
	exit 2
fi

sed -e "s/##VERSION##/${VERSION}/g; s/##RELEASE##/${CURRENT_RELEASE}/" $PKG.spec.in > $PKG.spec

make generateupstream || exit 3

make bumpnogit
git add $PKG.spec Makefile release upstream
git commit -s -m "Update to ${VERSION}"
make koji
