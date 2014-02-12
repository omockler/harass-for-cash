module HarassForCash
  module Routes
    class Base < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        enable :use_code
        
        Slim::Engine.default_options[:format] = :html5
        Slim::Engine.default_options[:layout] = :layout
      end

      register Extensions::Assets
      helpers Helpers
      helpers Sinatra::ContentFor
    end
  end
end