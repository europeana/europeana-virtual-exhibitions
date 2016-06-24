# Environment

This document describes the environment needed to run the Europeana Exhibitions CMS.

## Requirements

* ruby 2
* imagemagick
* postgres database
* redis (as page cache)
* swift container

## Environment variables

In *.env.example* an overview of all the environment variables used can be found.

### EUROPEANA_STYLEGUIDE_ASSET_HOST
Defines where the styleguide CSS will be loaded from.

### OPENSTACK_*
Defines openstack auth credentials, used to get access to the Swift container.

### IMAGES_CONTAINER_NAME and ATTACHMENTS_CONTAINER_NAME
Swift containers used to store images and attachments. Make sure to create these containers first in your swift environment.

### APP_HOST
In the setup used by Europeana requests are proxied through Apache. This setting is used to be able to build full URLs for images, sitemaps and links.

### APP_PORT
See above, only used in development.

## Swift container

Two swift containers are needed to run the CMS. One to store images and one to store attachments. At the moment the attachments are not used but please do setup the container to not mess with Alchemy.

The containers you create can be private since they are never directly accessed by the user.

## Redis

Compiling the templates is resource intensive so the full HTML is cached in redis. The app expects a *redis.yml* file in the config directory with the following contents:

```yml
production:
  host: <%= redis_config['credentials']['hostname'] %>
  port: <%= redis_config['credentials']['port'] %>
  password: <%= redis_config['credentials']['password'] %>
  name: <%= redis_config['credentials']['name'] %>
  db: 0
  namespace: cache
```

## Postgres

A postgres database is used to store everything. Nothing special here.

## ImageMagick

Used to resize images through [DragonFly](https://github.com/markevans/dragonfly), a recent version is advised.
