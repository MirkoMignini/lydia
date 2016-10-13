require 'rack/response'
require 'json'

module Lydia
  class Response < Rack::Response
    def initialize(*)
      super
      headers['Content-Type'] = 'text/html' if headers['Content-Type'].nil?
    end

    def build(input)
      input_class = input.class.to_s.downcase
      if %w(string array fixnum hash).include?(input_class)
        send("build_#{input_class}", input)
      else
        build_default(input)
      end
      finish
    end

    def finish(&block)
      @block = block
      if [204, 205, 304].include?(status.to_i)
        headers.delete('Content-Length')
        headers.delete('Content-Type')
        close
        [status.to_i, header, []]
      else
        [status.to_i, header, @body]
      end
    end

    private

    def build_string(input)
      write(input)
    end

    def build_array(input)
      @status = input.first
      write(input.last.is_a?(Array) ? input.last[0] : input.last)
      headers.merge!(input[1]) if input.count == 3
    end

    def build_fixnum(input)
      @status = input
    end

    def build_hash(input)
      headers['Content-Type'] = 'application/json'
      write(input.to_json)
    end

    def build_default(input)
      return write(input) if input.respond_to?(:each)
      raise(ArgumentError, "#{input.class} is not a valid allowed return type")
    end
  end
end
