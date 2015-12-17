require 'lydia/application'

class App < Lydia:Application
  get '/' do
    'Hello world!'
  end
end
