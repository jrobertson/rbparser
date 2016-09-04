#!/usr/bin/env ruby

# file: rbparser.rb

require 'app-routes'


class RbParser
  include AppRoutes

  attr_reader :to_a

  def initialize(s)

    super()
    params = {}
    expressions(@params)

    @to_a = scan_lines s
  end

  private  

  def expressions(params) 
    
    parse /#(.*)/ do |comment|
      [:comment, comment]
    end    

    parse /if (.*) then/ do |condtn|
      [:if, condtn]
    end

    parse /class\s+(\w+)/ do |clssnme|
      [:class, clssnme]
    end

    parse /end/ do
      [:end]
    end

    parse /def\s+(\w+)\s*\((?:\)|([^\)]+)\))/ do |mthdnme, argslst|      
      r = [:def, mthdnme]
      r << argslst if argslst
      r
    end

    parse /(\w+)\(([^\)]+)\)/ do |mthdnme, argslst|
      [:method, mthdnme, argslst]
    end
    
    parse /case\s+(\w+)/ do |arg|
      [:case, arg]
    end

    parse /when\s+(.*)/ do |expression|
      [:when, expression]
    end
    
    parse /else/ do 
      [:else]
    end   

    parse /elsif\s+(.*)/ do |cndtn|
      [:elsif, cndtn]
    end

    parse /(\w+)\s+([^\)]+)\s+/ do |mthdnme, argslst|
      [:method, mthdnme, argslst]
    end    
    
    parse /.*/ do
      [:blankline]
    end
  end

  alias parse get
  alias scan_line run_route


  def scan_lines(s)

    a = s.lines.inject([]) do |r,line|
      #puts 'line: ' + line.inspect
      line.strip.length > 0 ? r << scan_line(line) : r << [:blankline]

    end
    #puts 'a: ' + a.inspect
    treeize a
  end

  def treeize(a)

    r = []

    while a.length > 0 do

      id, *remaining = stmnt = a.shift

      case id
      when :class

        name, baseclass = remaining
        r << [:class, name]
        r.last.concat treeize(a)

      when :def

        name, *args = remaining
        r << [:def, name.to_sym, args]
        r.last.concat treeize(a)

      when :case

        expr = remaining.first
        r << [:case, expr]
        r.last.concat treeize(a)

      when :when

        expr = remaining.first
        r << [:when, expr]        
        
      when :method
        
        name, *args = remaining
        r << [:method_call, name.to_sym, args]

      when :end

       return r
       
      when :comment
        r << [:comment, remaining.join]
        
      when :blankline then r << [:blankline]

      end

    end

    r
  end

end