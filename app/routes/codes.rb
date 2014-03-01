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
        @codes = Code.all
        slim :print_codes, layout: false
      end
      
      get '/codes/sekret/show' do
        json Code.all.map { |c|  c.code }
      end

      get '/codes/sekret/:num' do |num|
        @codes = []
        num.to_i.times do
          @codes << Code.create
        end

        json @codes.map { |c| c.code }
      end

      get '/codes/:code' do |code|
        content_type 'image/png'
        halt 404 unless Code.first(code: code).present?
        image = RQRCode::QRCode.new("http://localhost:9292/enter/#{code}", :size => 14, :level => :h ).to_img
        image.to_blob
      end
    end
  end
end
