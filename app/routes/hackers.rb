module HarassForCash
  class App < Sinatra::Base
    include Helpers

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
      
      new_hacker = Hacker.create name: params[:full_name], email: params[:email], phone: params[:phone], school: params[:school], qr: code.code, event: current_or_next_event
      if new_hacker.present?
        code.destroy
        flash[:success] = "Hacker Created."
        enter_hacker new_hacker
        redirect '/hackers/current'
      else
        flash[:danger] = "Something went wrong while trying to save the hacker. Try again."
        redirect "/hackers/new/#{params[:qr]}"
      end
    end

    private
      def enter_hacker(hacker)
        raffle = current_or_next_event.raffles.detect { |r| is_current?(r) }
        raffle ||= current_or_next_event.raffles.where(:start_time.gte => Time.now.utc).sort(:start_time).first
        unless raffle.entries.any? { |h| h["id"] == hacker.id}
          raffle.entries << { id: hacker.id, email: hacker.email, phone: hacker.phone } 
          raffle.save
        end
      end

      def current_or_next_event
        @event ||= get_current_or_next_event
      end

      def get_current_or_next_event
        if Event.current.present?
          Event.current
        else
          Event.where(:start_time.gte => Time.now.utc).sort(:start_time).first
        end
      end

  end
end