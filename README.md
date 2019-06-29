# README

* Deployment instructions
- We follow Modulars Architecture
- Microservices

* Deploy production
 - Change variable 'env' in buybid_setup.sh to 'production'

* Known problems:
- If you have bundle problem 'Bundle Install could not fetch specs from https://rubygems.org/' please refer to https://stackoverflow.com/questions/49800432/gem-cannot-access-rubygems-org
- When you need to reset admin psw: https://stackoverflow.com/questions/14968254/spree-rails-user-password-reset
- Can not upload image to S3: MiniMagick::Invalid (ImageMagick/GraphicsMagick is not installed):
    + https://stackoverflow.com/questions/31193495/error-original-error-imagemagick-graphicsmagick-is-not-installed
    + [sudo apt-get install libmagickwand-dev] or [brew install imagemagick]
    + [sudo apt-get install imagemagick]
- String does not have #dig method (TypeError): caused by wrong master.key
- Admin: uninitialized constant Spree::StoreController (NameError), caused by missing [gem spree_frontend]

* Ruby version
- Ruby 2.6
- Rails 5.2.3

* System dependencies
- Base on Spree eCommerce framework
- MySQL

* Configuration
- Create DB user gant Full permission
  username: developments.buybid_jp
  password: Password123@

* Initialize

- Setup
> run <source path>/zzdev/shells/buybid_setup.sh

- Test data
> run <source path>/zzdev/shells/buybid_sample.sh

* Run Apps for Development

	1. Frontend
	> cd <source path>/buybid_frontend
	> bundle exec rails server -p 3000

	2. Admin
	> cd <source path>/buybid_admin
	> bundle exec rails server -p 3001

	3. Batch
	> cd <source path>/buybid_batch
	# run time_schedule triggers
	> ./run.sh time_schedule trigger for Market crawling,...
	# run Markets crawling workers
	> ./run.sh product_sneak
	# run Product cards processing
	> ./run.sh product_cards_fetch
	# run Product detail processing
	> ./run.sh product_detail_fetch
	# run Rpc Server
	> ./run.sh rpc_server
	> ..

* How to create models and migrations files
	1. Creating the models
		> cd source path>/spree_buybid_core
		> rails g models [attributes]
	
	2. Creating the migration files
		> cd source path>/spree_buybid_core/
		> rails g migration [migration-file-name] [migration-files-attributes]
		> cd source_path>/spree_setup
		> bundle exec rake railties:install:migrations FROM=spree_buybid_core
		> bundle exec rake db:migrate FROM=spree_buybid_core
