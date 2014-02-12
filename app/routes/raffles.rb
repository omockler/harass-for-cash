module HarassForCash
  module Routes
    class Raffles < Base

      get '/raffles' do
        Event.current.raffles
      end

      get '/raffles/current' do
        Event.current.raffles
        Raffles.where(:drawn_at => nil)
      end

      get '/raffles/current/draw' do

      end

    end
  end
end