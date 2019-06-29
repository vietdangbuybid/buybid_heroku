#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
echo ""
echo "  Buybid.jp Ruby projects bundler, invoked from: [${green}${PWD}${reset}]"
echo ""
CURRENT_DIRECTORY="${PWD}"
cd "${PWD}/$(dirname "$BASH_SOURCE")/../../"
SOURCE_ROOT_DIR="${PWD}"
echo "  - Source root: [${green}$SOURCE_ROOT_DIR${reset}]"

declare -a MODULES=( "buybid_common" "buybid_rpc" "buybid_markets" "buybid_fetch" "buybid_sneak" "buybid_admin" "buybid_batch" "buybid_frontend" "buybid_sample" "buybid_setup" )

for MODULE in "${MODULES[@]}"
do
  echo ""
  echo "*****************" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	echo "  - Module: ${green}$MODULE${reset} - [$SOURCE_ROOT_DIR/$MODULE]"
	echo "Module: $MODULE - [$SOURCE_ROOT_DIR/$MODULE]" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
  echo "*****************" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
  echo "" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	cd "$SOURCE_ROOT_DIR/$MODULE"
	#echo "bundle update"
	#spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	#bundle update
	#echo "bundle update rails"
	#spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	#bundle update rails
	#spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle install >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	if [ $? -eq 0 ]
	then
	  echo "    ${green}Success${reset}!"
	else
	  echo "    ${red}Failed${reset}!"
	  echo "    Open this file for more detail: $SOURCE_ROOT_DIR/zzdev_shells.log"
		break
	fi
  echo "" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
done
cd "$CURRENT_DIRECTORY"
echo "  ===============  Returned to: [${green}${PWD}${reset}]"
echo "  End"
echo ""
