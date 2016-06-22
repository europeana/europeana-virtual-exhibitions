# Europeana Virtual Exhibitions

[![Build Status](https://travis-ci.org/europeana/europeana-virtual-exhibitions.svg?branch=develop)](https://travis-ci.org/europeana/europeana-virtual-exhibitions) [![Coverage Status](https://coveralls.io/repos/github/europeana/europeana-virtual-exhibitions/badge.svg?branch=develop)](https://coveralls.io/github/europeana/europeana-virtual-exhibitions?branch=develop) [![security](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop.svg)](https://hakiri.io/github/europeana/europeana-virtual-exhibitions/develop) [![Dependency Status](https://gemnasium.com/europeana/europeana-virtual-exhibitions.svg)](https://gemnasium.com/europeana/europeana-virtual-exhibitions)

Europeana's Virtual Exhibitions as a Rails app using [Alchemy CMS](https://github.com/AlchemyCMS/alchemy_cms).

## Setup for development

* Clone the repository
* Run `bundle install`
* Copy .env.example to .env.development, and alter where needed
* Run `rake db:setup`
* Run `foreman s`
* Go to [http://0.0.0.0:3000](http://0.0.0.0:3000)
* Create an account and start creating some nice pages
