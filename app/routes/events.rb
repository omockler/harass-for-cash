module HarassForCash
  class App < Sinatra::Base

    get '/events' do
      @events = Event.all
      slim :events
    end

    post '/events' do
      halt 500, "Bad interval" unless params[:raffle_interval].to_i > 0

      event = Event.new name: params[:name],
        start_time: Time.parse(params[:start_time]),
        end_time: Time.parse(params[:end_time]),
        raffle_interval: params[:raffle_interval].to_i
      
      num_raffles = ((event.end_time - event.start_time) / event.raffle_interval.hours).ceil
      
      (1..num_raffles).map do |i|
        offset = (i - 1) * event.raffle_interval.hours
        start_time = event.start_time + offset
        end_time = event.start_time + offset + event.raffle_interval.hours
        event.raffles << Raffle.new(start_time: start_time, end_time: end_time)
      end
      
      event.save!
      flash[:success] = "Event Created Successfully."
      redirect "/events"
    end
  end
end