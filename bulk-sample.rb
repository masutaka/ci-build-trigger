require_relative 'ci-bundle-update'

exec_days = ENV['EXEC_DAYS']
github_username = ENV['GITHUB_USERNAME']
branch = ENV['BRANCH']
extra_build_parameters = ENV['EXTRA_BUILD_PARAMETERS']

# $TRIGGERS :: <CIRCLECI_TOKEN>:<GITHUB_REPONAME>,<CIRCLECI_TOKEN>:<GITHUB_REPONAME>,...
ENV['TRIGGERS'].split(',').each do |trigger|
   circleci_token, github_reponame = trigger.split(':')

   puts "GitHub repository is #{github_username}/#{github_reponame}"

   ci_bundle_update = CiBundleUpdate::CircleCi.new(circleci_token, exec_days, extra_build_parameters)
   ci_bundle_update.build(github_username, github_reponame, branch)
end
