# ci-bundle-update

Build your CircleCI project with build_parameters "{BUNDLE_UPDATE: true}"

## Setup

Click [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Open Heroku scheduler `ex. $ heroku addons:open scheduler --app <App Name>`

Add `$ bundle exec ruby ci-bundle-update.rb` to Heroku scheduler
