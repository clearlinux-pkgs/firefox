#!/bin/bash

VERSION="##VERSION##"
BASEDIR="/usr/share/firefox-stub"
SFILE="${BASEDIR}/firefox-${VERSION}.tar.bz2"
LFILE="${HOME}/firefox/firefox"
FDIR="${HOME}/firefox"
# p11-kit provides a "bridge" for libnss to access the trust information
NSSCKBI="${FDIR}/libnssckbi.so"
P11KIT_BRIDGE="/usr/lib64/p11-kit-trust.so"


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

if [ -f "$P11KIT_BRIDGE" ]; then
    # backup the original and replace it with a link
    if [ -f "$NSSCKBI" ]; then
        mv "$NSSCKBI" "${NSSCKBI}.orig"
        (cd $(dirname "$NSSCKBI") && ln -s "$P11KIT_BRIDGE" $(basename "$NSSCKBI"))
        if [ $? -ne 0 ]; then
            1>&2 echo "System trust store: failed to create bridge."
        fi
    else
        1>&2 echo System trust store: nss library not found $(basename "$NSSCKBI")
    fi
fi

exec "${LFILE}" $*
