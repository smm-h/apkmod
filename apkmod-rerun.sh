#!/bin/bash

set -e
source mod.conf

# Recompile
bash apkmod-recompile.sh

# [Re-]Install
if adb install $APP_NAME-mod.apk | grep -q "Install command complete"; then
    echo "Installed APK"
else
    echo "Failed to install APK; exiting..."
    exit 1
fi

# Run
adb shell monkey -p $PACKAGE_NAME -c android.intent.category.LAUNCHER 1

PID=`adb shell pidof $PACKAGE_NAME`

# Watch logs
adb logcat --pid=$PID
