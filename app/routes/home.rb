module HarassForCash
  class App < Sinatra::Base

    get '/' do
      
      slim :home
    end

  end
end