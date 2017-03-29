# ci-bundle-update

Build your CI project with build_parameters "{BUNDLE_UPDATE: true}"

It supports `CircleCI` and `Wercker`.

## Setup

1. Click [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
1. Open Heroku scheduler `ex. $ heroku addons:open scheduler --app <App Name>`
1. Add command to Heroku scheduler
   * **CircleCI**: `$ bundle exec ruby ci-bundle-update.rb`
   * **Wercker**: `$ bundle exec ruby ci-bundle-update.rb --ci wercker`

## More

In Japanese

http://masutaka.net/chalow/2015-07-28-1.html
