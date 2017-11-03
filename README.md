# ci-build-trigger

Build your CI project with build_parameters "{BUNDLE_UPDATE: true}" and more.

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

## Recommend for CircleCI users

You can use [Scheduling a Workflow](https://circleci.com/docs/2.0/workflows/#scheduling-a-workflow) of CircleCI 2.0. It provides scheduled build like crontab.

:bulb: So I recommend to use Scheduling a Workflow, not ci-build-trigger.
