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

      get '/hackers/new/:qr' do
        # TODO: Validate that code exists
        @qr = params[:qr]
        slim :new_hacker
      end

      post '/hackers' do #CREATE HACKER
        code = Code.first code: params[:qr]
        halt 404 unless code
        #TODO: Remove code after new hacker is added
        Hacker.create name: params[:name], email: params[:email], qr: code.code, event: Event.current
        redirect '/hackers/current'
      end

    end
  end
end