require 'rubygems'
require 'levenshtein'

module DidYouMean
  def self.included(base)
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

      unless method_defined? :method_missing
        def method_missing(meth, *args, &block); super; end
      end
      alias_method :method_missing_without_method_search, :method_missing
      alias_method :method_missing, :method_missing_with_method_search

    end

  end
  def method_missing_with_method_search(name,*args,&block)
    unless (self.respond_to? name)
      best_match = self.methods.search(name).first
      $stdout.print "Did you mean #{self.class}.#{best_match} (yes/no)?\n"
      response = $stdin.gets
      return self.send(best_match,*args,&block) if /yes/ =~ response
    end
    method_missing_without_method_search name,*args,&block
  end
end 
