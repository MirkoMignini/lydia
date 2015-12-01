module Lydia
  class Route    
    attr_reader :block

    def initialize(pattern, block)
      @regexp = Regexp.new("^#{pattern}$") if pattern.is_a? String
      @regexp = pattern if pattern.is_a? Regexp
      @block = block
    end

    def match?(env)
      @regexp.match("#{env['PATH_INFO']}") ? true : false
    end
  end 
end
