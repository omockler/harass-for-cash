require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)
require 'pry'
require 'dotenv'
Dotenv.load

# Require base
require 'sinatra/base'
require 'active_support/core_ext/string'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/json'
require 'rack-flash'
require 'sinatra/json'
require 'json'

libraries = Dir[File.expand_path('../lib/**/*.rb', __FILE__)]
libraries.each do |path_name|
  require path_name
end

require 'app/extensions'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module HarassForCash
  class App < Sinatra::Application
    helpers Sinatra::JSON

    configure do
      MongoMapper.database = "harassforcash"
    end

    configure :development, :staging do
      #database.loggers << Logger.new(STDOUT)
    end

    configure do
      disable :method_override
      disable :static

      set :sessions,
          httponly: true,
          secure: production?,
          secure: false,
          expire_after: 5.years,
          secret: ENV['SESSION_SECRET']
      enable :sessions
    end

    use Rack::Deflater
    use Rack::Standards
    use Rack::Flash, :sweep => true

    use Routes::Static

    unless settings.production?
      use Routes::Assets
    end

    # Other routes:
    use Routes::Events
    use Routes::Hackers
    use Routes::Codes
    use Routes::Entries
    use Routes::Raffles
  end
end

include HarassForCash::Models