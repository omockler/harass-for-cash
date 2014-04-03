require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

# Require base
require 'sinatra/base'
require 'warden'
require 'active_support/core_ext/string'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/json'
require 'rack-flash'
require 'sinatra/json'
require 'json'

require 'app/models'
require 'app/helpers'
require 'app/routes'
require './assets'

module HarassForCash
  class App < Sinatra::Base

    set :root, File.dirname(__FILE__)

    helpers Sinatra::JSON
    helpers Helpers

    configure do
      db = URI.parse(ENV['MONGOHQ_URL'])
      db_name = db.path.gsub(/^\//, '')
      conn = Mongo::Connection.new(db.host, db.port)
      conn.db(db_name).authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
      MongoMapper.connection = conn
      MongoMapper.database = db_name
    
      disable :method_override
      disable :static

      Slim::Engine.default_options[:format] = :html5
    end

    use Rack::Session::Cookie, secret: (ENV["SESSION_SECRET"] || "nothingissecretontheinternet")
    use Rack::Deflater
    use Rack::Standards
    use Rack::Flash, :sweep => true

    use Warden::Manager do |manager|
      manager.default_strategies :password
      manager.failure_app = App
      manager.serialize_into_session { |user| user.id }
      manager.serialize_from_session { |id| User.first id: id }
    end
     
    Warden::Manager.before_failure do |env,opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    Warden::Strategies.add(:password) do
      def valid?
        params["email"] || params["password"]
      end
     
      def authenticate!
        user = User.first email: params["email"]
        if user and user.authenticate(params["password"])
          success!(user)
        else
          fail!("Could not log in")
        end
      end
    end

    before /^(?!\/(login|\/|js|css|favicon|fonts))/ do
      check_authentication
    end
  end
end

include HarassForCash::Models