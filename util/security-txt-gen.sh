#!/bin/sh
SECURITY_KEY_ID="CA96989D4A3F7869F5DEB38DF9BE548EC3641B41"
SECURITY_EXPIRES=$(date -u -v +1y +"%Y-%m-%dT%H:%M:%S.000Z")
SECURITY_OUTPUT_PATH="src/security.txt"

if [ -n "$1" ]; then
    SECURITY_OUTPUT_PATH="$1"
fi

cat << EOF | gpg --clearsign -u "$SECURITY_KEY_ID" -o "$SECURITY_OUTPUT_PATH" --yes -
Contact: mailto:hello@joshbeard.com
Expires: $SECURITY_EXPIRES
Encryption: https://joshbeard.com/files/joshbeard-public.asc.txt
Encryption: https://keys.openpgp.org/search?q=0x${SECURITY_KEY_ID}
Preferred-Languages: en
Canonical: https://joshbeard.com/security.txt
EOF

echo "Signed security.txt generated as $SECURITY_OUTPUT_PATH"
