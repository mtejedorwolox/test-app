Poloniex Monitoring
===============

## Running local server

### 1- Installing Ruby

- Clone the repository by running `git clone git@github.com:mtejedorwolox/test-app.git`
- Go to the project root by running `cd test-app`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
```
- Install basic dependencies if you are using Ubuntu:

```bash
  sudo apt-get install build-essential libpq-dev nodejs
```

- Install all the gems included in the project.

```bash
  bundle install
```

### Database Setup

Run in terminal:

```bash
  sudo -u postgres psql
  CREATE ROLE "poloniex_monitoring" LOGIN CREATEDB PASSWORD 'poloniex_monitoring';
```

Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

Your server is ready to run. You can do this by executing `rails server` and going to [http://localhost:3000](http://localhost:3000).

## Deploy Guide

#### Heroku

If you want to deploy your app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL to your remotes
- Push to heroku

```bash
	git remote add heroku-prod your-git-url
	git push heroku-prod your-branch:master
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
7. Push your branch (`git push origin my-new-feature`)
8. Create a new Pull Request

## About

