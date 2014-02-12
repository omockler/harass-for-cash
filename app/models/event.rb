module HarassForCash
  module Models
    class Event
      include MongoMapper::Document

      def self.current
        first(:start_time.lte => Time.now, :end_time.gte => Time.now)
      end

      def self.current_raffle
        current.raffles.select { |r| r.start_time <= Time.now && r.end_time >= Time.now }.first
      end

      key :name,            String
      key :start_time,      Time
      key :end_time,        Time
      key :raffle_interval, Integer, numeric: true

      many :hackers
      many :raffles

      timestamps!

      validate :start_before_end

      def start_before_end
        if end_time < start_time
          errors.add(:start_time, "Start time must come before end time.")
        end
      end

    end
  end
end
