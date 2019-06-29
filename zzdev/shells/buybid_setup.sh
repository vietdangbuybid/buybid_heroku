#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
env="development"
echo ""
echo "  Buybid.jp Ruby setup, invoked from: [${green}${PWD}${reset}]"
echo ""
CURRENT_DIRECTORY="${PWD}"
cd "${PWD}/$(dirname "$BASH_SOURCE")/../../"
SOURCE_ROOT_DIR="${PWD}"

echo "${red}Running buybid_setup will drop your current databases and create new onces.${reset}"
echo ""

while true; do
    read -p "Do you wany to continue? (YyNn): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) ;;
    esac
done

copy_credentails()
{
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
}

clean_schemas()
{
	rm -f "$SOURCE_ROOT_DIR/buybid_admin/db/schema.rb"
	rm -f "$SOURCE_ROOT_DIR/buybid_batch/db/schema.rb"
	rm -f "$SOURCE_ROOT_DIR/buybid_sneak/db/schema.rb"
	rm -f "$SOURCE_ROOT_DIR/buybid_frontend/db/schema.rb"
	rm -f "$SOURCE_ROOT_DIR/buybid_setup/db/schema.rb"	
}

exit_error() 
{
	clean_schemas

	echo "  ${red}Failed${reset}!"
  echo "  Open this file for more detail: $SOURCE_ROOT_DIR/zzdev_shells.log"
	
	cd "$CURRENT_DIRECTORY"

	echo "  ${red}Failed${reset}!"
	echo "  ===============  Returned to: [${green}${PWD}${reset}]"
	echo "  End"
	echo ""
	exit 1
}

exit_success()
{
	clean_schemas

	cd "$CURRENT_DIRECTORY"

	echo "    ${green}Success${reset}!"
	echo "  ===============  Returned to: [${green}${PWD}${reset}]"
	echo "  End"
	echo ""
	exit 0
}

echo "    Begin dundler"

bash "$SOURCE_ROOT_DIR/zzdev/shells/buybid_bundle.sh"

if [ $? -eq 0 ] 
then
	echo "    End dundler"
else
	exit_error
fi

echo "  - Begin setup"
echo "  - Begin setup" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"

echo ""
echo "  - Module: ${green}buybid_setup${reset} - [$SOURCE_ROOT_DIR/buybid_setup]"
echo "Module: buybid_setup - [$SOURCE_ROOT_DIR/buybid_setup]" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
echo "*****************" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
echo "" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"

cd "$SOURCE_ROOT_DIR/buybid_setup"

spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
echo "     * bundle install"
bundle install >> "$SOURCE_ROOT_DIR/zzdev_shells.log"

if [ $? -eq 0 ] 
then
	echo "     * bundle exec rails db:environment:set RAILS_ENV=$env"
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails db:environment:set RAILS_ENV=$env
	echo "     * clean schemas"
	clean_schemas
	echo "     * copy credentails"
	copy_credentails
	declare -a LIBRARIES=( "buybid_common" "buybid_rpc" "spree_buybid_core" "buybid_markets" "buybid_fetch" "buybid_sneak"  )
	for LIBRARY in "${LIBRARIES[@]}"
	do
		spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
		echo "     * bundle exec rake railties:install:migrations FROM=$LIBRARY RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 "
		bundle exec rake railties:install:migrations FROM=$LIBRARY RAILS_ENV=$env
	done
	echo "     * bundle exec rails db:drop db:create db:migrate RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 "
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails db:drop db:create db:migrate RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	echo "     * bundle exec rails g spree:auth:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 "
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails g spree:auth:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
	echo "     * bundle exec rails g spree_gateway:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 "
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails g spree_gateway:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
	echo "     * bundle exec rails g spree_static_content:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 "
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails g spree_static_content:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
	declare -a LIBRARIES=( "buybid_common" "buybid_rpc" "spree_buybid_core" "buybid_markets" "buybid_fetch" "buybid_sneak" "spree_buybid_core" "spree_buybid_api"  )
	for LIBRARY in "${LIBRARIES[@]}"
	do
		spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
		echo "     * bundle exec rails g $LIBRARY:install DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
		bundle exec rails g $LIBRARY:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
	done
	echo "     * bundle exec rails db:seed RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
	spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	bundle exec rails db:seed RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
else
	exit_error
fi

declare -a MODULES=("buybid_batch" "buybid_admin" "buybid_frontend")

for MODULE in "${MODULES[@]}"
do
  echo ""
  echo "*****************" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
	echo "  - Module: ${green}$MODULE${reset} - [$SOURCE_ROOT_DIR/$MODULE]"
	echo "Module: $MODULE - [$SOURCE_ROOT_DIR/$MODULE]" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
  echo "*****************" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
  echo "" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"

	cd "$SOURCE_ROOT_DIR/$MODULE"

	if [ $? -eq 0 ] 
	then
		echo "     * bundle exec rails db:migrate db:seed RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
		spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
		bundle exec rails db:migrate db:seed RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 
		if [ $MODULE == "buybid_admin" ] || [ $MODULE == "buybid_frontend" ] 
		then
			if [ -f "$SOURCE_ROOT_DIR/$MODULE/config/initializers/devise.rb" ]
			then
				echo "     * devise installed"
			else
				spring stop >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
				echo "     * bundle exec rails g devise:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
				bundle exec rails g devise:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
				echo "     * bundle exec rails g spree_multi_currency:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
				bundle exec rails g spree_multi_currency:install RAILS_ENV=$env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
			fi
		fi
	  echo "    ${green}Success${reset}!"
	else
	  exit_error
	fi
  echo "" >> "$SOURCE_ROOT_DIR/zzdev_shells.log"
done
exit_success
