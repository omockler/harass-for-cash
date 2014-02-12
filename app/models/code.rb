module HarassForCash
  module Models
    class Code
      include MongoMapper::Document
      extend Dragonfly::Model

      key :code,          String, { required: true, default: -> { SecureRandom.hex } }
      key :qr_code_uid,   String
      
      dragonfly_accessor :qr_code
      belongs_to :hacker
      
      before_validation :update_qr_attr

      # TODO: get url from environment
      def update_qr_attr
        qr_code_img = RQRCode::QRCode.new("http://localhost:9292/enter/#{self.code}", :size => 14, :level => :h ).to_img
        self.qr_code = qr_code_img.to_string
        self.qr_code.name = "#{self.code}.png"
      end
    end
  end
end