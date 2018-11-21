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

    Process.run(first[0], first[1]) do | x |
      prev = x.output
      commands.each do | cmd |
        prev = Process.run(cmd[0], cmd[1], nil, false, false, prev, Process::Redirect::Pipe) { | x | x.output }
      end
      Process.run(last[0], last[1], nil, false, false, prev, STDOUT)
    end
  end
  
  def builtin?(command : Command)
    Bismuth::Builtins::BUILTINS.each do | cmd | 
      return true if command[0] == cmd 
    end
  end
end
