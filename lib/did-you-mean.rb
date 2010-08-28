require 'rubygems'
require 'levenshtein'

module DidYouMean
  
  module ClassMethods
    def methods_with_a_search
      methods_array = methods_with_no_search
      class << methods_array
        def search(query)
          self.sort_by {|name| Levenshtein.normalized_distance(name.to_s, query.to_s) }
        end
      end
      methods_array
    end
  end

  def self.included(base)
    base.class_eval do
      include DidYouMean::ClassMethods
      alias_method :methods_with_no_search, :methods
      alias_method :methods, :methods_with_a_search

      alias_method :method_missing_without_method_search, :method_missing
      alias_method :method_missing, :method_missing_with_method_search
    end
  end  

  def method_missing_with_method_search(name,*args,&block)
    unless self.respond_to? name
      best_match = self.methods.search(name).first
      $stdout.print "Did you mean #{self.class}.#{best_match} (Yes/no)?\n"
      response = $stdin.gets.strip
      return self.send(best_match,*args,&block) if /\A(yes|y|)\z/i =~ response
    end
    method_missing_without_method_search name,*args,&block 
  end

end 
