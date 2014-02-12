require './app'

Dragonfly.app.configure do
  url_format '/dragonfly/:job'
end

use Dragonfly::Middleware

run HarassForCash::App