module Lydia
  class Route
    attr_reader :regexp, :params, :request_method, :namespace, :pattern, :options, :block

    WILDCARD_REGEX = %r{\/\*(.*)}
    NAMED_SEGMENTS_REGEX = %r{\/([^\/]*):([^:$\/]+)}

    def initialize(request_method, namespace, pattern, options = {}, &block)
      @request_method = request_method
      @namespace = namespace
      @pattern = pattern
      @options = options
      @block = block
      if pattern.is_a? String
        path = (namespace || '') + pattern
        result = if path.match(WILDCARD_REGEX)
          path.gsub(WILDCARD_REGEX, '(?:/(.*)|)')
        elsif path.match(NAMED_SEGMENTS_REGEX)
          path.gsub(NAMED_SEGMENTS_REGEX, '/\1(?<\2>[^.$/]+)')
        else
          path
        end
        @regexp = Regexp.new("\\A#{result}\\z")
      elsif pattern.is_a?(Regexp)
        @regexp = Regexp.new((namespace || '') + pattern.to_s)
      else
        raise ArgumentError, 'Pattern must be a string or a regex'
      end
    end

    def match?(env)
      match = @regexp.match((env['PATH_INFO']).to_s)
      if match && match.names.size
        @params = Hash[match.names.map(&:to_sym).zip(match.captures)]
      end
      match
    end
  end
end
