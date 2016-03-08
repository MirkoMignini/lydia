require 'rack/response'
require 'json'

module Lydia
  class Response < Rack::Response
    def initialize(*)
      super
      headers['Content-Type'] = 'text/html' if headers['Content-Type'].nil?
    end

    def build(input)
      case input.class.to_s
      when 'String'
        write input
      when 'Array'
        @status = input.first
        write input.last.is_a?(Array) ? input.last[0] : input.last
        headers.merge!(input[1]) if input.count == 3
      when 'Fixnum'
        @status = input
      when 'Hash'
        headers['Content-Type'] = 'application/json'
        write input.to_json
      else
        if input.respond_to?(:each)
          write input
        else
          raise ArgumentError, "#{input.class} is not a valid allowed return type"
        end
      end
      finish
    end

    def finish(&block)
      @block = block

      if [204, 205, 304].include?(status.to_i)
        headers.delete 'Content-Length'
        headers.delete 'Content-Type'
        close
        [status.to_i, header, []]
      else
        [status.to_i, header, @body]
      end
    end
  end
end
