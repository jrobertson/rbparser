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

    get /(\w+)\(([^\)]+)\)/ do |mthdnme, argslst|
      [:method, mthdnme, argslst]
    end

  end

  alias parse get
  alias scan_line run_route


  def scan_lines(s)

    a = s.lines.inject([]) do |r,line|

      line.strip.length > 0 ? r << scan_line(line) : r

    end

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

      when :method
        
        name, *args = remaining
        r << [:method_call, name.to_sym, args]

      when :end

       return r

      end

    end

    r
  end

end