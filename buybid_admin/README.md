# README

This README would normally document whatever steps are necessary to get the
application up and running.

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
> rails g spree:install --migrate=false --sample=false --seed=false --copy_views=true
> rails g spree:install --user_class=Spree::User
> rails g spree:auth:install
> rails g spree_gateway:install

* Deployment instructions
- We follow Modulars Architecture
- Microservices
