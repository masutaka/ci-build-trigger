require 'circleci'
require 'httparty'

class CiBundleUpdate
  class Base
    def initialize(token, exec_days)
      @exec_days = exec_days
      post_initialize(token, exec_days)
    end

    def build
      raise NotImplementedError
    end

    private

    attr_reader :exec_days

    def post_initialize(token, exec_days)
      nil
    end

    def skip?
      exec_days &&
        ! exec_days.split(',').include?(Time.now.strftime('%a'))
    end
  end

  class CircleCi < Base
    def build(username, reponame, branch)
      if skip?
        puts "This build was skipped for $EXEC_DAYS (#{exec_days})"
        return
      end

      response = ::CircleCi::Project.build_branch(
        username, reponame, branch, {},
        build_parameters: { BUNDLE_UPDATE: true }
      )

      if response.success?
        puts "This build was accepted"
      else
        puts "This build was not accepted for #{response.body}"
      end
    end

    private

    def post_initialize(circleci_token, exec_days)
      ::CircleCi.configure do |config|
        config.token = circleci_token
      end
    end
  end

  class Wercker < Base
    include HTTParty

    base_uri 'https://app.wercker.com/api/v3'

    def build(username, reponame, branch)
      if skip?
        puts "This build was skipped for $EXEC_DAYS (#{exec_days})"
        return
      end

      application = get_application(username, reponame)
      build_pipeline = get_build_pipeline(application['id'], branch)
      raise 'build pipeline not found.' unless build_pipeline
      run_build(build_pipeline['id'], branch)
    end

    private

    def post_initialize(wercker_token, exec_days)
      @wercker_token = wercker_token
      @headers = {
        Authorization: "Bearer #{wercker_token}",
        'Content-type': 'application/json',
      }
    end

    def get_application(username, reponame)
      self.class.get("/applications/#{username}/#{reponame}", headers: @headers).parsed_response
    end

    def get_build_pipeline(application_id, branch)
      query = {
        applicationId: application_id,
        branch: branch,
      }

      runs = self.class.get('/runs', query: query, headers: @headers).parsed_response
      run = runs.find { |run| run['pipeline']['name'] == 'build' }
      run['pipeline'] if run
    end

    def run_build(pipeline_id, branch)
      body = {
        pipelineId: pipeline_id,
        branch: branch,
        envVars: [
          { key: 'BUNDLE_UPDATE', value: 'true' }
        ],
      }

      self.class.post('/runs', body: body.to_json, headers: @headers)
    end
  end
end

if $0 == __FILE__
  require 'optparse'
  options = ARGV.getopts(nil, 'ci:circle_ci')

  case options['ci']
  when 'circle_ci'
    ci_bundle_update = CiBundleUpdate::CircleCi.new(ENV['CIRCLECI_TOKEN'], ENV['EXEC_DAYS'])

  when 'wercker'
    ci_bundle_update = CiBundleUpdate::Wercker.new(ENV['WERCKER_TOKEN'], ENV['EXEC_DAYS'])
  end

  ci_bundle_update.build(ENV['GITHUB_USERNAME'], ENV['GITHUB_REPONAME'], ENV['BRANCH'])
end
