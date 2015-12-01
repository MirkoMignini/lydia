require 'rack/response'

module Lydia
  class Response < Rack::Response    
    def initialize(*)
      super
      self['Content-Type'] = 'text/html' if self['Content-Type'].nil?
    end
    
    def build()
      result = yield
      if result.is_a? String
        write result
      elsif result.is_a? Array
        self.status = result.first
        write result.last.is_a?(Array) ? result.last[0] : result.last
        self.header.merge(result[1]) if result.count == 3
      elsif result.is_a? Fixnum
        self.status = result.to_i
        write ''
      elsif result.is_a? Hash
        self['Content-Type'] = 'application/json'
        write result.to_json
      elsif result.respond_to?(:each)
        result.each { |item| write item }
      end    
      finish
    end
  end
end
