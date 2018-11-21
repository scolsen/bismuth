# TODO: Write documentation for `Bismuth`

require "readline"
require "./bismuth/**"

module Bismuth
  VERSION = "0.1.0"
  include Bismuth::Line
  include Bismuth::Builtins 
  include Bismuth::Dispatch
  extend self
  
  @@line  : String | Nil 
  @@parsed   : Array(String)
  
  @@parsed  = [] of String
  
  def start
    loop do
      @@line = Readline.readline("bismuth> ", true)
      break if @@line.nil?
     
      dispatch(commands(@@line.as(String)))
    end
  end
end

Bismuth.start
