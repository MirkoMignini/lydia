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
          filters[filter.to_sym] << Route.new(@namespace, pattern, options, block)
        end
      end
    end
    
    def dispatch(env, params)
      process_before_filters(env)
      result = super(env, params)
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
  end
end