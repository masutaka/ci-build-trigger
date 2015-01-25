require 'circleci'

if ENV['EXEC_DAYS'] &&
   ! ENV['EXEC_DAYS'].split(',').include?(Time.now.strftime('%a'))
  exit 0
end

CircleCi.configure do |config|
  config.token = ENV['CIRCLECI_TOKEN']
end

CircleCi::Project.build_branch(
  ENV['GITHUB_USERNAME'],
  ENV['GITHUB_REPONAME'],
  ENV['BRANCH'],
  {BUNDLE_UPDATE: true},
)
