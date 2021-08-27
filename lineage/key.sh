rm -f /tmp/key.pem
openssl pkcs8 -in ~/.android-certs/releasekey.pk8 -inform DER -nocrypt -out /tmp/key.pem
python2 ./lineage/external/avb/avbtool extract_public_key --key /tmp/key.pem --output ./pkmd.bin
fastboot erase avb_custom_key
fastboot flash avb_custom_key ./pkmd.bin
