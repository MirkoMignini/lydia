require 'lydia/standard_pages'
require 'lydia/route'
require 'lydia/not_found'

module Lydia
  class Router
    include StandardPages
    
    class << self
      def routes
        @routes ||= Hash.new { |h, k| h[k] = [] }
      end
      
      %w(HEAD GET PATCH PUT POST DELETE OPTIONS).each do |request_method|
        define_method(request_method.downcase) do |pattern, &block|
          routes[request_method] << Route.new(pattern, block)
        end
      end
      
      def dispatch(env)
        routes[env['REQUEST_METHOD']].each do |route|
          return route.block if route.match?(env)
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
