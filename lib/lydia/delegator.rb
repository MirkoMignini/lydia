require 'lydia/application'

module Lydia
  module Delegator
    [:head, :get, :patch, :put, :post, :delete, :options].each do |method|
      define_method(method) do |*args, &block|
        Lydia::Application.send(method, *args, &block)
      end
    end
  end
end