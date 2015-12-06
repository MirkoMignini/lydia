module Lydia
  module Helpers
    def content_type(content)
      @response.header['Content-Type'] = content
    end
    
    def redirect(target, status = 302)
      [status, target]
    end    
  end
end