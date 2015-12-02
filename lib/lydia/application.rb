require 'lydia/router'
require 'lydia/view'
require 'lydia/response'

module Lydia
  class Application < Router
    extend View
    include StandardPages
    
    def process
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
