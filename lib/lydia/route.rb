module Lydia
  class Route    
    attr_reader :regexp, :params, :namespace, :pattern, :options, :block
    
    WILDCARD_REGEX = /\/\*(.*)/.freeze
    NAMED_SEGMENTS_REGEX = /\/([^\/]*):([^:$\/]+)/.freeze

    def initialize(namespace, pattern, options = {}, &block)
      @namespace = namespace
      @pattern = pattern
      @options = options
      @block = block
      if pattern.is_a? String
        path = (namespace || '') + pattern
        if path.match(WILDCARD_REGEX)
          result = path.gsub(WILDCARD_REGEX, '(?:/(.*)|)')
        elsif path.match(NAMED_SEGMENTS_REGEX)
          result = path.gsub(NAMED_SEGMENTS_REGEX, '/\1(?<\2>[^.$/]+)')
        else
          result = path
        end
        @regexp = Regexp.new("\\A#{result}\\z")
      elsif pattern.is_a?(Regexp)
        @regexp = pattern
      else
        raise ArgumentError.new('Pattern must be a string or a regex')
      end
    end

    def match?(env)
      match = @regexp.match("#{env['PATH_INFO']}")
      @params = Hash[match.names.map(&:to_sym).zip(match.captures)] if match && match.names.size
      match
    end
  end 
end
