require 'lydia/router'
require 'lydia/view'
require 'lydia/response'

module Lydia
  class Application < Router
    include View
    include StandardPages
    
    def process
      Response.new.build {
        begin
          instance_eval(&dispatch(env))
        rescue NotFound
          not_found(env)
        rescue StandardError => exception
          internal_server_error(env, exception)
        end
      }
    end
  end  
end
