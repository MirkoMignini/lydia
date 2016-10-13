require 'forwardable'
require 'rack/builder'
require 'lydia/router'
require 'lydia/templates'
require 'lydia/filters'
require 'lydia/helpers'
require 'lydia/request'
require 'lydia/response'

module Lydia
  class Application < Router
    include Templates
    include Filters
    include Helpers

    def process
      result = super
      if result.nil?
        @response.build(200)
      elsif result.class <= Rack::Response
        result.finish
      else
        @response.build(result)
      end
    end

    def new_request(env)
      Lydia::Request.new(env)
    end

    def new_response(body = [], status = 200, header = {})
      Lydia::Response.new(body, status, header)
    end

    class << self
      extend Forwardable

      def_delegators :builder, :map, :use, :run

      def builder
        @builder ||= Rack::Builder.new
      end

      def new(*args, &bk)
        builder.run(super(*args, &bk))
        builder.to_app
      end
    end
  end
end
