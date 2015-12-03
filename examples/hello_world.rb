$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'lydia'

get '/' do
  'Hello world!'
end