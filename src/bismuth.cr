# TODO: Write documentation for `Bismuth`

require "readline"

module Bismuth
  VERSION = "0.1.0"
  extend self

  @@command : String | Nil

  # TODO: Put your code here
  def start
    loop do
      @@command = Readline.readline("bismuth> ")
      break if @@command.nil?
      puts @@command
    end
  end
end

Bismuth.start
