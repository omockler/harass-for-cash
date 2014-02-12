module HarassForCash
  module Helpers
    
    def is_current? item
      if item.respond_to?(:start_time) && item.respond_to?(:end_time)
        item.start_time <= Time.now && item.end_time >= Time.now
      end
    end

    def flash_types
      [:success, :info, :warning, :danger]
    end

  end
end