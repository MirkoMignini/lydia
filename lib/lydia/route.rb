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
      @regexp = init_regexp
    end

    def match?(env)
      match = @regexp.match((env['PATH_INFO']).to_s)
      if match && match.names.size
        @params = Hash[match.names.map(&:to_sym).zip(match.captures)]
      end
      match
    end

    private

    def init_regexp
      return regexp_from_string if @pattern.is_a? String
      return Regexp.new((@namespace || '') + @pattern.to_s) if @pattern.is_a?(Regexp)
      raise(ArgumentError, 'Pattern must be a string or a regex')
    end

    def regexp_from_string
      path = (@namespace || '') + @pattern
      result = if path.match(WILDCARD_REGEX)
        path.gsub(WILDCARD_REGEX, '(?:/(.*)|)')
      elsif path.match(NAMED_SEGMENTS_REGEX)
        path.gsub(NAMED_SEGMENTS_REGEX, '/\1(?<\2>[^.$/]+)')
      else
        path
      end
      Regexp.new("\\A#{result}\\z")
    end
  end
end
