require "./types"

module Bismuth::Builtins
  include Bismuth::Types 
  extend self 

  BUILTINS = [ "cd",
               "pwd",
               "exit"]

  # Change the current directory for the bismuth process. 
  def cd(args : Args | Nil)
    return if args.nil?
    dir = args.first 
    if !Dir.exists?(dir)
      puts "Not a directory."
      return 
    else  
      Dir.cd(dir)
    end
  end

  def pwd
    puts Dir.current
  end

  def ex
    exit 0
  end

  def run(command : Command)
    case command[0]
    when "cd"   then cd(command[1])
    when "pwd"  then pwd
    when "exit" then ex
    else             return
    end
  end
end
