# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

To reset the database locally:

```
rails db:drop db:create db:setup
```

To reset the database on Heroku:

```
heroku restart; heroku pg:reset DATABASE; heroku run rake db:migrate db:seed
```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
