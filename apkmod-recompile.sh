#!/bin/bash

set -e
source mod.conf

# Build
apktool b -o $APP_NAME-mod.apk $APP_NAME
# cp $APP_NAME/dist/$APP_NAME.apk $APP_NAME.apk

# Align
zipalign -f 4 $APP_NAME-mod.apk $APP_NAME-aligned.apk

if ! zipalign -c -v 4 $APP_NAME-aligned.apk | grep -q "Verification succesful"; then
    echo "APK is not aligned; exiting..."
    exit 1
fi

if ! zipalign -c -v 4 $APP_NAME-aligned.apk | grep -q "resources.arsc (OK)"; then
    echo "resources.arsc must not be compressed; exiting..."
    exit 1
fi

rm $APP_NAME-mod.apk
cp $APP_NAME-aligned.apk $APP_NAME-mod.apk

# Sign
apksigner sign --ks=$KS_NAME.jks --ks-pass pass:$KS_PASS $APP_NAME-mod.apk

if apksigner verify $APP_NAME-mod.apk | grep -q "DOES NOT VERIFY"; then
    echo "APK signature check failed; exiting..."
    exit 1
fi
