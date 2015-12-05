require 'forwardable'
require 'rack/builder'
require 'lydia/router'
require 'lydia/view'
require 'lydia/response'

module Lydia
  class Application < Router
    include View
    
    def process
      Response.new.build(super)
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
