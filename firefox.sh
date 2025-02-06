#!/bin/bash

VERSION="##VERSION##"
USER_CONFIG="${HOME}/.config/firefox.conf"

if [ -f "${USER_CONFIG}" ]; then
    source "${USER_CONFIG}"
fi

BASEDIR="/usr/share/firefox-stub"
SFILE="${BASEDIR}/firefox-${VERSION}.tar.zst"
FIREFOX_INSTALL_DIR=${FIREFOX_INSTALL_DIR:-"${HOME}/.firefox"}
LFILE="${FIREFOX_INSTALL_DIR}/firefox"
# p11-kit provides a "bridge" for libnss to access the trust information
NSSCKBI="${FIREFOX_INSTALL_DIR}/libnssckbi.so"
P11KIT_BRIDGE="/usr/lib64/pkcs11/p11-kit-trust.so"

# if the system trust strore symlink exists, then all is in place
if [ -L "${NSSCKBI}" ] ; then
    exec "${LFILE}" $*
    exit 0
fi

if [[ ! -x "${LFILE}" ]]; then
    if [[ -x /usr/bin/notify-send ]]; then
        /usr/bin/notify-send -i firefox "Preparing Firefox" "Firefox will launch shortly, please wait for it to be prepared for the first use."
    fi
    mkdir -p "${FIREFOX_INSTALL_DIR}"
    tar xf "${SFILE}" -C "${FIREFOX_INSTALL_DIR}" --strip-components=1
fi

# use system trust store
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
