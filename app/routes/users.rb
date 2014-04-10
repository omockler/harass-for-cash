module HarassForCash
  class App < Sinatra::Base
    
    get '/users' do
      @users = User.all
      slim :users
    end

    post '/users' do
      begin
        user = User.create! email: params["email"].downcase, password: params["password"], password_confirmation: params["password"]
        flash[:success] = "#{user.email} was entered in this raffle."
      rescue
        flash[:error] = "Could not create user"  
      end
      redirect '/users'
    end
  end
end
