require 'rack/response'

module Lydia
  class Response < Rack::Response    
    def initialize(*)
      super
      self['Content-Type'] = 'text/html' if self['Content-Type'].nil?
    end
    
    def build()
      result = yield
      case result.class.to_s
        when 'String'
          write result
        when 'Array'
          @status = result.first
          write result.last.is_a?(Array) ? result.last[0] : result.last
          headers.merge!(result[1]) if result.count == 3        
        when 'Fixnum'
          @status = result
        when 'Hash'
          headers['Content-Type'] = 'application/json'
          write result.to_json        
        else
          if result.respond_to?(:each)
            write result
          else  
            raise ArgumentError.new("#{result.class} is not a valid allowed return type")
          end
      end
      finish
    end
  end
end
