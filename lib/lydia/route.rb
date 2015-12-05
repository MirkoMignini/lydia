module Lydia
  class Route    
    attr_reader :block, :regexp, :params
    
    WILDCARD_REGEX = /\/\*(.*)/.freeze
    NAMED_SEGMENTS_REGEX = /\/([^\/]*):([^:$\/]+)/.freeze

    def initialize(pattern, block)
      @block = block
      if pattern.is_a? String
        if pattern.match(WILDCARD_REGEX)
          result = pattern.gsub(WILDCARD_REGEX, '(?:/(.*)|)')
        elsif pattern.match(NAMED_SEGMENTS_REGEX)
          result = pattern.gsub(NAMED_SEGMENTS_REGEX, '/\1(?<\2>[^.$/]+)')
        else
          result = pattern
        end
        @regexp = Regexp.new("\\A#{result}\\z")
      elsif pattern.is_a? Regexp
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
