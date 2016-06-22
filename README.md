# Europeana Virtual Exhibitions

[![Build Status](https://travis-ci.org/europeana/europeana-virtual-exhibitions.svg?branch=develop)](https://travis-ci.org/europeana/europeana-virtual-exhibitions) [![Coverage Status](https://coveralls.io/repos/github/europeana/europeana-virtual-exhibitions/badge.svg?branch=develop)](https://coveralls.io/github/europeana/europeana-virtual-exhibitions?branch=develop) [![security](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop.svg)](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop) [![Dependency Status](https://gemnasium.com/europeana/europeana-virtual-exhibitions.svg)](https://gemnasium.com/europeana/europeana-virtual-exhibitions)

Europeana's Virtual Exhibitions as a Rails app using [Alchemy CMS](https://github.com/AlchemyCMS/alchemy_cms).

## License

Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).

## Requirements
* Ruby 2.x (latest stable version recommended)
* Redis
* PostgreSQL

## Preparation
* Create a PostgreSQL db
* Create a Redis data store

## Installation
* Clone this repository
* Configure with environment variables. See [.env.example](.env.example) for available variables, and in development/test copy this to .env.development or .env.test. Be sure to set `DATABASE_URL` to the URL of your PostgreSQL db.
* Create config/redis.yml with a Redis URL for your environment. See samples beneath [deploy/](deploy/).
* Run `bundle install`
* Run `bundle exec rake db:setup`

## Usage
* Run each command in the Procfile as a separate app instance. In development, use `foreman start` to run all.
* The root URL of the application is /portal/exhibitions
* Create an admin account at /portal/exhibitions/admin/signup
* See [Alchemy CMS documentation](http://guides.alchemy-cms.com/) for general guidance on using the CMS.
