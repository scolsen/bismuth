require "./types"

module Bismuth::Line
  include Bismuth::Types 

  def commands(line : String)
    parts = [] of String
    cmds  = [] of Command

    line.split(" | ") do | part |
      cmds << command(part) 
    end

    return cmds
  end

  def command(linepart : String)
    parts = [] of String
    
    linepart.split(" ") do | part |
      parts << part  
    end
    
    first = parts.shift
    return {first, parts} unless parts.empty?
    return {first, nil}
  end
end
