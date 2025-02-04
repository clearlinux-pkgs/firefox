#!/bin/bash
set -e -o pipefail

PKG=firefox

git pull --ff-only
# The `sed ... | sort --version-sort | sed ...` part of the pipeline forces
# beta releases sort correctly, leveraging the fact that the tilde character
# sorts before any other character when using --version-sort.
VERSION=$(curl -sSf https://archive.mozilla.org/pub/firefox/releases/ \
	    | grep href \
	    | cut -f3 -d">" \
	    | cut -f1 -d"/" \
	    | sed 's/b/~/' \
	    | sort --version-sort \
	    | sed 's/~/b/' \
	    | grep -Ex '(91\.0b[0-9]+|[0-9.]+)' \
	    | tail -1)
	    
echo "version is ${VERSION}"	  

if [[ -z "${VERSION}" ]]; then
    echo "Unable to find version upstream."
    exit 1
fi

CURRENT_VERSION=$(grep "^Version" $PKG.spec | awk '{ print $3 }')
CURRENT_RELEASE=$(grep "^Release" $PKG.spec | awk '{ print $3 }')

if [[ v"${CURRENT_VERSION}" == v"${VERSION}" ]]; then
	exit
fi

sed -e "s/##VERSION##/${VERSION}/g; s/##RELEASE##/${CURRENT_RELEASE}/" $PKG.spec.in > $PKG.spec

# Check that the substituted URLs are actually valid. If not, try to fix them.
for url in $(grep -iE '(URL|SOURCE)[0-9]*\s*:' $PKG.spec | grep -oE 'https://\S+'); do
	echo Testing url $url
	if ! curl -sSIf "${url}"; then
		echo "Unable to fetch ${url}"

		# Strip the extension and try the common ones
		base=${url%%.tar.*}
		for ext in .tar.zst .tar.bz2 .tar.gz .tar.xz; do
			if curl -ssIf "${base}${ext}"; then
				sed -i "s#${url}#${base}${ext}#" $PKG.spec
				break
			fi
		done
	fi
done

make generateupstream || exit 3

make bumpnogit
git add $PKG.spec Makefile release upstream
git commit -a -m "Update to ${VERSION}"
make koji-nowait
