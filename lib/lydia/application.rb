require 'forwardable'
require 'rack/builder'
require 'lydia/router'
require 'lydia/view'
require 'lydia/filters'
require 'lydia/helpers'
require 'lydia/request'
require 'lydia/response'

module Lydia
  class Application < Router
    include View
    include Filters
    include Helpers
    
    def process
      @response.build(super)
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

      alias new! new
      
      def new(*args, &bk)
        app = new!(*args, &bk)
        builder.run app
        builder.to_app
      end
    end
  end  
end
