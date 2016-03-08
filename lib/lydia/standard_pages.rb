module Lydia
  module StandardPages
    def not_found(env = nil)
      message = '<html><body>'\
                '<h1>Not Found</h1>'\
                "<p>No route matches #{env['REQUEST_METHOD']} #{env['PATH_INFO']}</p>"\
                '</body></html>'
      [404, { 'Content-Type' => 'text/html', 'Content-Length' => message.length.to_s }, [message]]
    end

    def internal_server_error(_env = nil, exception = nil)
      message = "<html><body><h1>Internal server error</h1><p>#{exception}</p></body></html>"
      [500, { 'Content-Type' => 'text/html', 'Content-Length' => message.length.to_s }, [message]]
    end

    def halted(_env = nil)
      message = '<html><body><h1>Application halted</h1></body></html>'
      [500, { 'Content-Type' => 'text/html', 'Content-Length' => message.length.to_s }, [message]]
    end
  end
end
