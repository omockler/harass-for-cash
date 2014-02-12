module HarassForCash
  module Routes
    class Codes < Base
      
      get '/codes/available' do
        # TODO: Implement View
        @codes = Code.all
        slim :codes
      end
      
      get '/codes/new' do
        slim :new_codes
      end
      
      post '/codes/new' do
        @codes = []
        params[:num].to_i.times do
          @codes << Code.create
        end
        slim :print_codes, layout: false
      end
      
      get '/codes/available/print' do
        @codes = Codes.all
        slim :print_codes
      end

    end
  end
end