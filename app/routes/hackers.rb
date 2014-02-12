module HarassForCash
  module Routes
    class Hackers < Base
      
      get '/hackers' do
        @hackers = Hacker.all
        slim :hackers
      end

      get '/hackers/current' do
        @hackers = Event.current.hackers
        slim :hackers
      end

      get '/hackers/new/:qr' do |qr|
        halt(500, "Bad Registration Code") unless Code.first(code: qr)
        
        @qr = qr
        slim :new_hacker
      end

      post '/hackers' do #CREATE HACKER
        code = Code.first code: params[:qr]
        halt 404 unless code
        
        if Hacker.create name: params[:name], email: params[:email], qr: code.code, event: Event.current
          code.destroy
          flash[:success] = "Hacker Created."
          redirect '/hackers/current'
        else
          flash[:danger] = "Something went wrong while trying to save the hacker. Try again."
          redirect "/hackers/new/#{params[:qr]}"
        end
      end

    end
  end
end