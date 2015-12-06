module Lydia
  class Halted < StandardError
    attr_reader :content
    def initialize(content)
      @content = content
      super
    end
  end
end