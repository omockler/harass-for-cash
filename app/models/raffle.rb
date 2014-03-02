module HarassForCash
  module Models
    class Raffle
      include MongoMapper::EmbeddedDocument

      key :start_time,  Time
      key :end_time,    Time
      key :drawn,       Boolean, default: false
      key :winner,      Hash
      key :entries,     Array
    end
  end
end