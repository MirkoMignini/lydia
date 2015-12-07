module Lydia
  module Helpers
    def content_type(content)
      @response.header['Content-Type'] = content
    end
    
    def redirect(target, status = 302)
      [status, target]
    end
    
    def params
      @request.params
    end
    
    def send_file(path, mime_type = nil)
      #todo
    end
  end
end