require 'rubygems'
require 'levenshtein'

module DidYouMean
  def self.included(base)
      # base.extend SomeOtherModule
      base.class_eval do
          
          def methods_with_a_search
            methods_array = methods_with_no_search
            class << methods_array
              def search(query)
                self.sort_by {|name| Levenshtein.normalized_distance(name.to_s, query.to_s) }
              end
            end
            methods_array
          end
          alias_method :methods_with_no_search, :methods
          alias_method :methods, :methods_with_a_search
      end
  end 
end