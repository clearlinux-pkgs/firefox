#!/bin/bash

VERSION="$1"

if [[ -z "${VERSION}" ]]; then
    echo "Please pass the new version first."
    exit 1
fi

sed template.spec -e "s/\#\#VERSION\#\#/${VERSION}/g" > firefox.spec
