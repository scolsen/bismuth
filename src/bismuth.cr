# TODO: Write documentation for `Bismuth`

require "readline"
require "./bismuth/**"

module Bismuth
  VERSION = "0.1.0"
  include Bismuth::Builtins 
  include Bismuth::Dispatch
  extend self
  
  @@command : String | Nil 
  @@parsed  : Array(String)

  @@parsed = [] of String
  
  def start
    loop do
      @@command = Readline.readline("bismuth> ", true)
      break if @@command.nil?
      
      @@command.as(String).split(" ") { |s| @@parsed << s }
      
      case @@parsed[0]
      when .starts_with?("cd")  then cd(@@parsed[1])
      when .starts_with?("pwd") then pwd
      when .starts_with?("exit") then ex
      else run(@@parsed[0], @@parsed[1..-1]) 
      end
    
      @@parsed.clear
    end
  end
end

Bismuth.start
