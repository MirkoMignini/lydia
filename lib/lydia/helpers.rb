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

    def send_file(_path, _mime_type = nil)
      raise(NotImplementedError, 'Send file not yet implemented.')
    end
  end
end
