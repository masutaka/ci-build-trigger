require 'circleci'
require 'httparty'

class CiBundleUpdate
  class Base
    def initialize(token, exec_days)
      @exec_days = exec_days
    end

    def build
      raise NotImplementedError
    end

    private

    attr_reader :exec_days

    def skip?
      exec_days &&
        ! exec_days.split(',').include?(Time.now.strftime('%a'))
    end
  end

  class CircleCi < Base
    def initialize(circleci_token, exec_days)
      super

      CircleCi.configure do |config|
        config.token = circleci_token
      end
    end

    def build(username, reponame, branch)
      if skip?
        puts "This build was skipped for $EXEC_DAYS (#{exec_days})"
        return
      end

      response = CircleCi::Project.build_branch(
        username, reponame, branch, {},
        build_parameters: { BUNDLE_UPDATE: true }
      )

      if response.success?
        puts "This build was accepted"
      else
        puts "This build was not accepted for #{response.body}"
      end
    end
  end

  class Wercker < Base
    include HTTParty

    base_uri 'https://app.wercker.com/api/v3'

    def initialize(wercker_token, exec_days)
      super

      @wercker_token = wercker_token
      @headers = {
        Authorization: "Bearer #{wercker_token}",
        'Content-type': 'application/json',
      }
    end

    # See: http://devcenter.wercker.com/docs/api/endpoints/builds#trigger-a-build
    #
    def build(username, reponame, branch)
      if skip?
        puts "This build was skipped for $EXEC_DAYS (#{exec_days})"
        return
      end

      response = self.class.get("/applications/#{username}/#{reponame}", headers: @headers).parsed_response

      body = {
        applicationId: response['id'],
        branch: branch,
        envVars: [
          { key: 'BUNDLE_UPDATE', value: 'true' }
        ],
      }

      self.class.post('/builds', body: body.to_json, headers: @headers)
    end
  end
end

if $0 == __FILE__
  ci_bundle_update = CiBundleUpdate::CircleCi.new(ENV['CIRCLECI_TOKEN'], ENV['EXEC_DAYS'])
  ci_bundle_update.build(ENV['GITHUB_USERNAME'], ENV['GITHUB_REPONAME'], ENV['BRANCH'])
end
