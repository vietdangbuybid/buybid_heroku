#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
env="development"
echo ""
echo "  Buybid.jp Ruby credentials, invoked from: [${green}${PWD}${reset}]"
echo ""
CURRENT_DIRECTORY="${PWD}"
cd "${PWD}/$(dirname "$BASH_SOURCE")/../../"
SOURCE_ROOT_DIR="${PWD}"

echo "${red}Running buybid_credentials will overwrite your current credentials.${reset}"
echo ""

while true; do
    read -p "Do you wany to continue? (YyNn): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) ;;
    esac
done

cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc.$env" "$SOURCE_ROOT_DIR/buybid_admin/config/credentials.yml.enc"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/master.key.$env" "$SOURCE_ROOT_DIR/buybid_admin/config/master.key"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc.$env" "$SOURCE_ROOT_DIR/buybid_batch/config/credentials.yml.enc"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/master.key.$env" "$SOURCE_ROOT_DIR/buybid_batch/config/master.key"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc.$env" "$SOURCE_ROOT_DIR/buybid_frontend/config/credentials.yml.enc"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/master.key.$env" "$SOURCE_ROOT_DIR/buybid_frontend/config/master.key"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc.$env" "$SOURCE_ROOT_DIR/buybid_sample/config/credentials.yml.enc"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/master.key.$env" "$SOURCE_ROOT_DIR/buybid_sample/config/master.key"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc.$env" "$SOURCE_ROOT_DIR/buybid_setup/config/credentials.yml.enc"
cp -f "$SOURCE_ROOT_DIR/buybid_setup/config/master.key.$env" "$SOURCE_ROOT_DIR/buybid_setup/config/master.key"

