require 'lydia/route'

module Lydia
  module Filters
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def filters
        @filters ||= Hash.new { |h, k| h[k] = [] }
      end
      
      %w(before after).each do |filter|
        define_method(filter) do |pattern = '/*', options = {}, &block|
          filters[filter.to_sym] << Route.new(filter, @namespace || '', pattern, options, &block)
        end
      end
      
      def redirect(pattern, options = {})
        return ArgumentError.new('Options must contains :to') unless options.include?(:to)
        filters[:redirect] << Route.new('redirect', @namespace || '', pattern, options)
      end
    end
    
    def dispatch(env)
      process_redirects(env)
      process_before_filters(env)
      result = super(env)
      process_after_filters(env)
      result
    end
    
    %w(before after).each do |filter_type|
      define_method("process_#{filter_type}_filters") do |env|
        self.class.filters[filter_type.to_sym].each do |filter|
          instance_eval(&filter.block) if filter.match?(env)
        end
      end
    end
    
    def process_redirects(env)
      self.class.filters[:redirect].each do |redirect|
        if redirect.match?(env)
          env['PATH_INFO'] = redirect.namespace + redirect.options[:to]
          @request = new_request(env)
          break
        end
      end
    end
  end
end