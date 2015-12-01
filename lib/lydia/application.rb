require 'lydia/router'
require 'lydia/view'
require 'lydia/response'

module Lydia
  class Application < Router
    extend View
    include StandardPages
    
    def initialize(&block)
      instance_eval(&block) if block
    end
    
    def self.call(env)
      new.call(env)
    end
    
    def call(env)
      dup._call(env)
    end
    
    def _call(env)
      Response.new.build {
        begin
          dispatch(env).call(env)
        rescue NotFound
          not_found(env)
        rescue Exception => exception
          internal_server_error(env, exception)
        end
      }
    end
  end  
end
