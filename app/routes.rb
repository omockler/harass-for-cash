module HarassForCash
  module Routes
    autoload :Assets, 'app/routes/assets'
    autoload :Base, 'app/routes/base'
    autoload :Static, 'app/routes/static'

    # Other routes:
    # autoload :Posts, 'app/routes/posts'
    autoload :Events,   'app/routes/events'
    autoload :Entries,  'app/routes/entries'
    autoload :Raffles,  'app/routes/raffles'
    autoload :Hackers,  'app/routes/hackers'
    autoload :Codes,    'app/routes/codes'
  end
end