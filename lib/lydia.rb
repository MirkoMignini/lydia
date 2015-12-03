require 'rack'
require 'lydia/application'
require 'lydia/delegator'
require 'lydia/version'

module Lydia
  at_exit { Rack::Handler.default.run(Application) }
end

extend Lydia::Delegator