module HarassForCash
  class App < Sinatra::Base

    get '/login' do
      slim :login
    end

    post "/login" do
      warden.authenticate!
      if warden.authenticated?
        redirect "/events" 
      else
        redirect "/login"
      end
    end
   
    get "/logout" do
      warden.logout
      redirect '/login'
    end
   
    post "/unauthenticated" do
      redirect "/login"
    end
  end
end