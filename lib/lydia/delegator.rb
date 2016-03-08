require 'lydia/application'
require 'forwardable'

module Lydia
  module Delegator
    extend Forwardable
    def_delegators  Lydia::Application,
                    :head, :get, :patch, :put, :post, :delete, :options,
                    :namespace, :before, :after,
                    :map, :use, :run
  end
end
