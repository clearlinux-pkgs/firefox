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

if [[ -x /usr/bin/notify-send ]]; then
    /usr/bin/notify-send -i firefox "Preparing Firefox" "Firefox will launch shortly, please wait for it to be prepared for the first use."
fi

cd "${HOME}"
tar xf "${SFILE}"

exec "${LFILE}" $*
