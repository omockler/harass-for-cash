module HarassForCash
  module Models
    class Raffle
      include MongoMapper::EmbeddedDocument

      key :start_time,  Time
      key :end_time,    Time
      key :drawn,       Boolean, default: false

      #many :entries
    end
  end
end