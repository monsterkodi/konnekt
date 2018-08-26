#!/usr/bin/env bash
cd `dirname $0`/../js
rm -f online.zip
rm -rf online
zip -q online.zip *
~/s/colorls/bin/color-ls -lp online.zip
