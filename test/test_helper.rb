ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'test/unit'

require 'bundler/setup'
require 'rack/test'

require './konklone'
require './test/factories'
require 'timecop'

set :environment, :test

module TestHelper

  module Methods

    # Test::Unit hooks

    def setup
      Timecop.freeze
    end

    def teardown
      Mongoid.models.each &:delete_all
      Timecop.return
    end

    # helper helpers
    class AnonymousRendering; extend Helpers::Rendering; end
    def routing; AnonymousRendering; end

    # Sinatra helpers

    def app
      Sinatra::Application
    end

    def login(user)
      {"rack.session" => {'user_id' => user.id.to_s}}
    end

    def session(hash = {})
      {"rack.session" => hash}
    end

    def redirect_path
      if last_response.headers['Location']
        last_response.headers['Location'].sub(/http:\/\/example.org/, '')
      else
        nil
      end
    end

    def assert_response(status, message = nil)
      assert_equal status, last_response.status, (message || last_response.body)
    end

    def assert_redirect(path)
      assert_response 302
      assert_equal path, redirect_path
    end

  end
end