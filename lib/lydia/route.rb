module Lydia
  class Route    
    attr_reader :block, :regexp
    
    WILDCARD_PATTERN = /\/\*(.*)/
    NAMED_SEGMENTS_PATTERN = /\/([^\/]*):([^:$\/]+)/

    def initialize(pattern, block)
      @block = block
      if pattern.is_a? String
        if pattern.match(WILDCARD_PATTERN)
          result = pattern.gsub(WILDCARD_PATTERN, '(?:/(.*)|)')
          puts result
        elsif pattern.match(NAMED_SEGMENTS_PATTERN)
          #todo
        else
          result = pattern
        end
        @regexp = Regexp.new("\\A#{result}\\z")
      elsif pattern.is_a? Regexp
        @regexp = pattern
      elsif pattern.responds_to?(:to_s)
        @regexp = Route.new(pattern.to_s, block).regexp
      else
        raise ArgumentError.new('Pattern must be a string or a regex')
      end
    end

    def match?(env)
      @regexp.match("#{env['PATH_INFO']}") ? true : false
    end
  end 
end
