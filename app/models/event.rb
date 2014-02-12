module HarassForCash
  module Models
    class Event
      include MongoMapper::Document

      def self.current
        first(:start_time.lte => Time.now, :end_time.gte => Time.now)
      end

      # TODO: Validate end after start
      key :name,            String
      key :start_time,      Time
      key :end_time,        Time
      key :raffle_interval, Integer

      many :hackers
      many :raffles

      timestamps!
    end
  end
end