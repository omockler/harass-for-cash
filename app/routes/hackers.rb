module HarassForCash
  class App < Sinatra::Base
    
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
      
      new_hacker = Hacker.create name: params[:full_name], email: params[:email], qr: code.code, event: current_or_next_event
      if new_hacker.present?
        code.destroy
        flash[:success] = "Hacker Created."
        # TODO: Maybe Enter the hacker in a raffle if there is one in progress.
        redirect '/hackers/current'
      else
        flash[:danger] = "Something went wrong while trying to save the hacker. Try again."
        redirect "/hackers/new/#{params[:qr]}"
      end
    end

    private

      def current_or_next_event
        if Event.current.present?
          Event.current
        else
          Event.where(:start_time.gte => Time.now).sort(:start_time).first
        end
      end

  end
end