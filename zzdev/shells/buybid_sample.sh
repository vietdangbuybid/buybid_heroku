#!/bin/bash

CURRENT_DIRECTORY="${PWD}"
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo ""
echo "  Buybid.jp Ruby load sample data, invoked from: [${green}$CURRENT_DIRECTORY${reset}]"
echo ""
cd "${PWD}/$(dirname "$BASH_SOURCE")/../../"

SOURCE_ROOT_DIR="${PWD}"

echo "  - Begin load"

echo ""
echo "  - Module: ${green}buybid_sample${reset} - [$SOURCE_ROOT_DIR/buybid_sample]"

cd "$SOURCE_ROOT_DIR/buybid_sample"

spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
bundle install
spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
bundle exec rake spree_sample:load

echo "    Copy images to buybid_frontend"
cp -R "$SOURCE_ROOT_DIR/buybid_sample/storage" "$SOURCE_ROOT_DIR/buybid_frontend"
echo "    Copy images to buybid_admin"
cp -R "$SOURCE_ROOT_DIR/buybid_sample/storage" "$SOURCE_ROOT_DIR/buybid_admin"

cd "$CURRENT_DIRECTORY"

echo "  ===============  Returned to: [${green}${PWD}${reset}]"
echo "  - End load"
echo ""
