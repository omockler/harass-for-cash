module HarassForCash
  class App < Sinatra::Base

    get '/entries' do
      @entries = Event.current_raffle.entries
      slim :entries
    end

    get '/enter/:id' do |id|
      hacker = get_hacker id

      raffle = Event.current_raffle
      halt(500, "No Current Raffle") unless raffle
      
      unless raffle.entries.any? { |h| h["id"] == hacker.id}
        raffle.entries << { id: hacker.id, email: hacker.email, phone: hacker.phone } 
        raffle.save
      end

      flash[:success] = "#{hacker.name} was entered in this raffle."
      redirect '/entries'
    end

    private

      def get_hacker code
        # If code is not claimed, register a new hacker with that code
        hacker = Hacker.first(qr: code)
        redirect "/hackers/new/#{code}" unless hacker
        hacker
      end
  end
end
