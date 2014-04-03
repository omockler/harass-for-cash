module HarassForCash
  class App < Sinatra::Base

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

      def current_or_last_event
        if Event.current.present?
          Event.current
        else
          Event.where(:end_time.lte => Time.now.utc).sort(:start_time).last
        end
      end

      def draw_closed_raffles
        winners = current_or_last_event.raffles.select { |r| r.drawn }.map { |r| r.winner }
        undrawn = current_or_last_event.raffles.select { |r| r.end_time <= Time.now.utc && !r.drawn && r.entries.count > 0 }
        undrawn.each do |r|
          while !r.drawn do
            potential_winner = r.entries.sample
            unless winners.detect { |w| w == potential_winner["id"] }
              r.winner = potential_winner
              r.drawn = true
            end
          end
          r.save
        end
      end
  end
end