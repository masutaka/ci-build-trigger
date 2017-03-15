# ci-bundle-update

Build your CircleCI project with build_parameters "{BUNDLE_UPDATE: true}"

## Setup

1. Click [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
1. Open Heroku scheduler `ex. $ heroku addons:open scheduler --app <App Name>`
1. Add `$ bundle exec ruby ci-bundle-update.rb` to Heroku scheduler

## More

In Japanese

http://masutaka.net/chalow/2015-07-28-1.html

# Recommend

AWS Lambda version is now available!

https://github.com/tsub/circleci-build-trigger
