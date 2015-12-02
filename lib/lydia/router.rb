require 'lydia/standard_pages'
require 'lydia/route'
require 'lydia/not_found'
require 'lydia/request'

module Lydia
  class Router
    include StandardPages
    
    class << self      
      attr_reader :request, :env, :params
      
      def routes
        @routes ||= Hash.new { |h, k| h[k] = [] }
      end
      
      %w(HEAD GET PATCH PUT POST DELETE OPTIONS).each do |request_method|
        define_method(request_method.downcase) do |pattern, &block|
          routes[request_method] << Route.new(pattern, block)
        end
      end
      
      def dispatch(env)
        @env = env
        @request = Request.new(env)
        @params = @request.params
        routes[env['REQUEST_METHOD']].each do |route|
          if route.match?(env)
            @params.merge!(route.params) if route.params
            return route.block 
          end
        end
        raise NotFound
      end
    end
    
    def call(env)
      dup._call(env)
    end
    
    def _call(env)
      begin
        self.class.dispatch(env).call(env)
      rescue NotFound
        not_found(env)
      rescue Exception => exception
        internal_server_error(env, exception)
      end
    end
    
    def dispatch(env)
      self.class.dispatch(env)
    end 
  end
end