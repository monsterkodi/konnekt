#!/usr/bin/env bash

cd `dirname $0`/..

konrad -R

cd `dirname $0`/../js

../node_modules/.bin/babel-minify *.js -d .
../node_modules/.bin/minify style.css > style.min.css
../node_modules/.bin/minify index.html > index.min.html
mv style.min.css style.css
mv index.min.html index.html

rm -f online.zip
rm -rf online
zip -q online.zip *

~/s/colorls/bin/color-ls -lp online.zip
