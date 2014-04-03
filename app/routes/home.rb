module HarassForCash
  class App < Sinatra::Base

    get '/' do
      @event = current_or_next_event
      if @event.present?
        # This doesn't account for the event starting in the future
        @next_raffle = @event.raffles.first { |r| r.start_time > Time.now.utc && r.end_time < Time.now.utc }
      end
      slim :home
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