$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lydia/application'

class App < Lydia::Application
  get '/' do
    'Hello world!'
  end
end

run App.new
