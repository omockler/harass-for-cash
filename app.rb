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
require 'active_support/core_ext/string'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'
require 'active_support/json'
require 'rack-flash'
require 'sinatra/json'
require 'json'
require 'pry'
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

      set :sessions,
          httponly: true,
          secure: production?,
          secure: false,
          expire_after: 5.years,
          secret: ENV['SESSION_SECRET']
      enable :sessions
      Slim::Engine.default_options[:format] = :html5
    end

    use Rack::Deflater
    use Rack::Standards
    use Rack::Flash, :sweep => true
  end
end

include HarassForCash::Models