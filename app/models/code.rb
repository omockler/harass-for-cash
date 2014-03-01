module HarassForCash
  module Models
    class Code
      include MongoMapper::Document

      key :code, String, { required: true, default: -> { SecureRandom.hex } }
      
    end
  end
end