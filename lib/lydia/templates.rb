require 'tilt'

module Lydia
  module Templates
    def render(file, scope = nil, locals = {}, &block)
      template = Tilt.new(file)
      template.render(scope, locals, &block)
    end
  end
end
