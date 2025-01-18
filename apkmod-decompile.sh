#!/bin/bash

set -e
source mod.conf

# Decompile
apktool d -f $APP_NAME.apk
