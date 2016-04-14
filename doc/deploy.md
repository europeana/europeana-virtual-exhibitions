# Deploy

The Exhibitions CMS is a very regular rails application so you should be able to deploy it to either CloudFoundry or Heroku without any issues. Check the *Procfile* to see which processes should be running.

See the *environment* document for a detailed outline of the environment required to deploy the CMS.

## Deploying to CloudFoundy/anynines

While Heroku is smart about not recompiling assets that where compiled in the past CloudFoundy is little less clever. To speed up deploy times it is advisable to precompile assets locally before pushing them to CloudFoundry.

There is one minor thing to keep in mind for the CloudFoundry buildpack to find the manifest of compiled you need to copy it. So run the following sequence of commands before pushing to CF.

```
bundle package --all
bundle exec rake assets:clean
bundle exec rake assets:precompile

## Copy deployment files into root
cp -r ./deploy/anynines/. .

## Copy manifest so buildpack detects it
mkdir -p ./public/assets
cp ./public/portal/exhibitions/assets/*.json ./public/assets
```

See my pull request for the heroku ruby [buildpack](https://github.com/heroku/heroku-buildpack-ruby/pull/479) for a more detailed discussion about why this does not work.

*Update 14/4/2016* Not relevant since Europeana moved to pivotal hosting.
