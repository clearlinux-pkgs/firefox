#!/bin/bash

VERSION="##VERSION##"
BASEDIR="/usr/share/firefox-stub"
SFILE="${BASEDIR}/firefox-${VERSION}.tar.bz2"
LFILE="${HOME}/firefox/firefox"
FDIR="${HOME}/firefox"

if [[ -x "${LFILE}" ]] ; then
    exec "${LFILE}" $*
    exit 0
fi

if [[ -d "${FDIR}" ]]; then
    echo "Exiting as ${FDIR} exists."
    exit 1
fi

cd "${HOME}"
tar xf "${SFILE}"

exec "${LFILE}" $*
