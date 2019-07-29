# Europeana Virtual Exhibitions

[![Build Status](https://travis-ci.org/europeana/europeana-virtual-exhibitions.svg?branch=develop)](https://travis-ci.org/europeana/europeana-virtual-exhibitions) [![Security](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop.svg)](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop) [![Maintainability](https://api.codeclimate.com/v1/badges/b46fa837092ee9e5e108/maintainability)](https://codeclimate.com/github/europeana/europeana-virtual-exhibitions/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/b46fa837092ee9e5e108/test_coverage)](https://codeclimate.com/github/europeana/europeana-virtual-exhibitions/test_coverage)

Europeana's Virtual Exhibitions as a Rails app using [Alchemy CMS](https://github.com/AlchemyCMS/alchemy_cms).

## License

Licensed under the EUPL v1.2.

For full details, see [LICENSE.md](LICENSE.md).

## Requirements
* Ruby 2.x (latest stable version recommended)
* ImageMagick
* Redis
* PostgreSQL

## Preparation
* Create a PostgreSQL db
* Create a Redis data store

## Installation
* Clone this repository
* Configure with environment variables. See [.env.example](.env.example) for available variables, documented in [doc/environment.md](doc/environment.md), and in development/test copy this to .env.development or .env.test. Be sure to set `DATABASE_URL` to the URL of your PostgreSQL db.
* Create config/redis.yml with a Redis URL for your environment. See samples beneath [deploy/](deploy/).
* Run `bundle install`
* Run `bundle exec rake db:setup`

## Usage
* Run each command in the Procfile as a separate app instance. In development, use `foreman start` to run all.
* The root URL of the application is /portal/exhibitions
* Create an admin account at /portal/exhibitions/admin/signup
* See [Alchemy CMS documentation](http://guides.alchemy-cms.com/) for general guidance on using the CMS.

## Docker

A Dockerfile is included, optimised for small image size, for publication to a
Docker repository and use in production environments.

### Configure version

```shell
export VERSION=2.3.0
```

### Build

```shell
docker build -t europeana/virtual-exhibitions:${VERSION} .
```

### Run

```shell
docker run \
       -p 8080:80 \
       --env-file=.env.docker \
       europeana/virtual-exhibitions:${VERSION}
```

### Publish
```shell
docker push europeana/virtual-exhibitions:${VERSION}
```
