# Introducing the Rbparser Gem

    require 'rbparser'

    s = "
    class Fun2

      def initialize()
        puts('hello')
      end
      
      def start(s='')
        puts('more to come')
      end
    end
    "

    RbParser.new(s).to_a

    #=&gt; [[:class, [:def, [:method_call]], [:def, [:method_call]]]]

## Resources

* ?rbparser https://rubygems.org/gems/rbparser?

rbparser gem
