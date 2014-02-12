module HarassForCash
  module Routes
    class Raffles < Base

      get '/raffles' do
        draw_closed_raffles
        @event = Event.current
        @raffles = @event.raffles
        slim :raffles
      end

      get '/raffles/current' do
        draw_closed_raffles
        @event = Event.current
        @raffle = Event.current_raffle

        slim :current_raffle
      end

      private

        def draw_closed_raffles
          # TODO: Make sure no one wins twice
          undrawn = Event.current.raffles.select { |r| r.end_time <= Time.now && !r.drawn }
          undrawn.each do |r|
            r.winner = r.entries.sample
            r.drawn = true
          end
        end
    end
  end
end