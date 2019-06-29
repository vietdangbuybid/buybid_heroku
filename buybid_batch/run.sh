#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo ""
echo "======= Running batch: $1 $2 ..."

if [ -z "$1" ]
then
	echo "  Invalid command!"
	echo "  bash <...>/${red}run.sh <command> <environment>${reset}"
	exit 1
fi

CMD_NAME=$1
RAILS_ENV=$2

if [ -z "$2" ]
then
	RAILS_ENV="development"
fi

echo "  command: ${green}$CMD_NAME${reset}"
echo "  environments: ${green}$RAILS_ENV${reset}"

# start Product Cards Fetch, fetch downloaded product information from queue(RabbitMQ) then store to main db(mysql)
if [ $CMD_NAME == "product_cards_fetch" ] || [ $CMD_NAME == "all" ] 
then
	bundle exec rails r -e $RAILS_ENV "Markets::ProductCardsFetchRunner.new.run"
	echo "  started: ${green}Markets::ProductCardsFetchRunner${reset}"
fi

# start Product Detail Fetch, fetch downloaded product information from queue(RabbitMQ) then store to main db(mysql)
if [ $CMD_NAME == "product_detail_fetch" ] || [ $CMD_NAME == "all" ] 
then
	bundle exec rails r -e $RAILS_ENV "Markets::ProductDetailFetchRunner.new.run"
	echo "  started: ${green}Markets::ProductDetailFetchRunner${reset}"
fi

# start Product Sneak, who retrieves tasks to download product information from markets (Yahoo,..) then store to queue(RabbitMQ)
if [ $CMD_NAME == "product_sneak" ] || [ $CMD_NAME == "all" ] 
then
	bundle exec rails sneakers:run WORKERS=Markets::ProductDetailsSneaker,Markets::ProductCardsSneaker RAILS_ENV=$RAILS_ENV
	echo "  started: ${green}Sneak workers${reset}"
fi

# start time schedules
if [ $CMD_NAME == "time_schedule" ] || [ $CMD_NAME == "all" ] 
then
	bundle exec clockwork run/clockworks/time_schedule.rb -e $RAILS_ENV
	echo "  started: ${green}Markets::TimeScheduleRunner${reset}"
fi

# start rpc server
if [ $CMD_NAME == "rpc_server" ] || [ $CMD_NAME == "all" ] 
then
	bundle exec gruf -e $RAILS_ENV
	echo "  started: bundle exec gruf"
fi

echo ""
echo "======= Done!"
echo ""
echo ""
