require 'lydia/route'
require 'lydia/standard_pages'
require 'lydia/not_found'
require 'lydia/halted'
require 'rack/request'
require 'rack/response'

module Lydia
  class Router
    include StandardPages
    
    attr_reader :request, :response, :env
    
    class << self      
      def routes
        @routes ||= Hash.new { |h, k| h[k] = [] }
      end
      
      %w(HEAD GET PATCH PUT POST DELETE OPTIONS).each do |request_method|
        define_method(request_method.downcase) do |pattern, options = {}, &block|
          routes[request_method] << Route.new(request_method, @namespace, pattern, options, &block)
        end
      end
      
      def namespace(pattern, options = {})
        prev_namespace = @namespace ||= ''
        @namespace += pattern
        yield
        @namespace = prev_namespace
      end
    end
    
    def next_route
      throw :next_route
    end  
    
    def halt(input = nil)
      raise Halted.new(input || halted)
    end
    
    def call(env)
      dup._call(env)
    end
    
    def _call(env)
      @env = env
      @request = new_request(env)
      @response = new_response
      process
    end
    
    def new_request(env)
      Rack::Request.new(env)
    end
    
    def new_response(body = [], status = 200, header = {})
      Rack::Response.new(body, status, header)
    end
    
    def process
      dispatch(env)
      rescue NotFound
        not_found(env)
      rescue Halted => exception
        exception.content
      rescue StandardError => exception
        internal_server_error(env, exception)
    end
    
    def routes
      self.class.routes
    end
    
    def dispatch(env)
      routes[env['REQUEST_METHOD']].each do |route|
        if route.match?(env)
          @request.params.merge!(route.params) if route.params
          catch(:next_route) do
            return instance_eval(&route.block)
          end
        end
      end
      raise NotFound
    end  
  end
end