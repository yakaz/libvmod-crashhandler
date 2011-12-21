#!/bin/bash -e

if [ -d .git ] && [ "$(git status --porcelain | grep -E '^\?\?' | wc -l)" -gt 0 ]; then
	echo "Clean your repository before!"
	exit 1
fi

VARNISH_VERSION="$(cat debian/VARNISH_VERSION)"
files="$(grep -l -F '${VARNISH_VERSION}' -R debian/)"
echo 'Replacing ${VARNISH_VERSION} in the following files, for "'"$VARNISH_VERSION"'":'
echo "$files"
echo 'Creating backups in debian/before_sed/'
mkdir debian/before_sed
echo "$files" | while read f; do dest="debian/before_sed/$(dirname "$f")"; mkdir -p "$dest"; cp "$f" "$dest/"; done
echo "$files" | xargs -d "\n" sed -i -e 's/\${VARNISH_VERSION}/'"$VARNISH_VERSION"'/g'

echo "Checking out varnish code version $VARNISH_VERSION..."
rm -Rf debian/varnish-sources
mkdir debian/varnish-sources
cd debian/varnish-sources
apt-get source --only-source --tar-only varnish=$VARNISH_VERSION
ftar="$(ls varnish_*.tar*)"
folder="$(tar tf "$ftar" | grep -E '^[^/]+/$')"
folder="${folder%/}"
tar xf "$ftar"
cd ../..

echo 'Running autogen.sh'
./autogen.sh
export LOCAL_CONFIGURE_FLAGS="$LOCAL_CONFIGURE_FLAGS 'VARNISHSRC=debian/varnish-sources/$folder'"

echo 'Building package...'
dpkg-buildpackage -b -us -uc -tc
echo 'Finished building package.'

echo 'Cleaning'
./clean.sh

echo 'Removing varnish sources'
rm -Rf debian/varnish-sources

echo 'Undoing replacement of ${VARNISH_VERSION}'
echo "$files" | while read f; do fn="$(basename "$f")"; orig="debian/before_sed/$(dirname "$f")"; mv "$orig/$fn" "$f"; rmdir --ignore-fail-on-non-empty "$orig"; done
rmdir debian/before_sed
