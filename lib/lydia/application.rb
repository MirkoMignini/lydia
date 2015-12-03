require 'lydia/router'
require 'lydia/view'
require 'lydia/response'

module Lydia
  class Application < Router
    include View
    include StandardPages
    
    def process
      Response.new.build {
        super
      }
    end
  end  
end
