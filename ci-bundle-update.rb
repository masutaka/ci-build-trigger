require 'circleci'

CircleCi.configure do |config|
  config.token = ENV['CIRCLECI_TOKEN']
end

CircleCi::Project.build_branch(
  ENV['GITHUB_USERNAME'],
  ENV['GITHUB_REPONAME'],
  ENV['BRANCH'] || 'master',
  {BUNDLE_UPDATE: true},
)
