require "sinatra/assetpack"
module HarassForCash
  class App < Sinatra::Base
    set :root, File.dirname(__FILE__)
    Less.paths <<  "#{App.root}/app/css" 
    register Sinatra::AssetPack

    assets do
      serve '/css',     :from => 'app/css'
      serve '/js',      :from => 'app/js'

      js :main, "/js/main.js", [
        "/js/jquery.min.js",
        "/js/bootstrap.min.js"
      ]
      css :main, "/css/main.css", [
        "/css/bootstrap.css",
        "/css/layout.css"
      ]
      css :print, "/css/print.css", [
        "/css/print_page.css"
      ]

      prebuild true
    end
    #"http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css",
  end
end
