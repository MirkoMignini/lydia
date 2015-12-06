require 'lydia/standard_pages'
require 'lydia/route'
require 'lydia/not_found'
require 'lydia/halted'
require 'lydia/request'

module Lydia
  class Router
    include StandardPages
    
    attr_reader :request, :env, :params
    
    class << self      
      def routes
        @routes ||= Hash.new { |h, k| h[k] = [] }
      end
      
      %w(HEAD GET PATCH PUT POST DELETE OPTIONS).each do |request_method|
        define_method(request_method.downcase) do |pattern, options = {}, &block|
          routes[request_method] << Route.new(@namespace, pattern, options, block)
        end
      end
      
      def namespace(pattern, options = {})
        prev_namespace = @namespace ||= ''
        @namespace += pattern
        yield
        @namespace = prev_namespace
      end
      
      def call(env)
        new.call(env)
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
      @request = Request.new(env)
      @params = @request.params
      process
    end
    
    def process
      begin
        dispatch(env, params)
      rescue NotFound
        not_found(env)
      rescue Halted => exception
        exception.content
      rescue StandardError => exception
        internal_server_error(env, exception)
      end      
    end
    
    def dispatch(env, params)
      self.class.routes[env['REQUEST_METHOD']].each do |route|
        if route.match?(env)
          params.merge!(route.params) if route.params
          catch (:next_route) do
            return instance_eval(&route.block)
          end
        end
      end
      raise NotFound
    end  
  end
end