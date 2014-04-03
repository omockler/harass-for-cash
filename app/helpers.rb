module HarassForCash
  module Helpers
    
    def is_current? item
      if item.respond_to?(:start_time) && item.respond_to?(:end_time)
        item.start_time <= Time.now.utc && item.end_time >= Time.now.utc
      end
    end

    def flash_types
      [:success, :info, :warning, :danger]
    end

    def warden
      env["warden"]
    end

    def check_authentication
      redirect '/login' unless warden.authenticated?
    end

    def current_user
      warden.user
    end
  end
end