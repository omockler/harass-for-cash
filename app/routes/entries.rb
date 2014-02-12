module HarassForCash
  module Routes
    class Entries < Base

      get '/entires' do
        slim :entries
      end

      get '/enter/:id' do |id|
        # If code is not claimed, register a new hacker with that code
        hacker = get_hacker id

        raffle = Event.current.raffles.first(drawn: false)
        halt(500, "No Current Raffle") unless raffle
        
        Entry.create hacker: hacker, raffle: raffle
        redirect '/entries'
      end

      private

        def get_hacker code
          hacker = Hacker.first(qr: id)
          redirect "/hackers/new/#{id}" unless hacker
          hacker
        end
    end
  end
end
