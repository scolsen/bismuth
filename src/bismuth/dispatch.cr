require "./types"
require "./builtins"

module Bismuth::Dispatch 
  include Bismuth::Types 

  def dispatch(commands : Commands)
    case commands.size
    when 0 then return
    when 1 then oneshot(commands[0])
    when 2 then twoshot(commands)
    else        nshot(commands)
    end
  end

  def oneshot(command : Command)
    if builtin? command 
      Bismuth::Builtins.run(command)
      return
    else 
      Process.run(command[0], command[1], nil, false, false, STDIN, STDOUT) 
    end
  end

  def twoshot(commands : Commands)
    Process.run(commands[0][0], commands[0][1]) do | x |
      Process.run(commands[1][0], commands[1][1], nil, false, false, x.output, STDOUT)
    end
  end

  def nshot(commands : Commands)
    first = commands.shift 
    last  = commands.pop    
    reader, writer = IO.pipe
    prev = reader

    Process.run(first[0], first[1], input: STDIN, output: writer) 
    writer.close 
    
    unless commands.empty?
      commands.each do | cmd |
        r, w = IO.pipe
        Process.run(cmd[0], cmd[1], input: prev, output: w)
        w.close
        prev = r
      end
    end

    Process.run(last[0], last[1], input: prev, output: STDOUT)
  end
  
  def builtin?(command : Command)
    Bismuth::Builtins::BUILTINS.each do | cmd | 
      return true if command[0] == cmd 
    end
  end
end
