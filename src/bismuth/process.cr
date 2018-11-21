module Bismuth::Dispatch
  def run(inp : String)
    commands = [] of String
    sp = [] of Array(String)
    inp.split(" | ") { |s| commands << s } 
    commands.each do |s|
      sp << s.split(' ')
    end

    Process.run(sp.first.first) do | x |
      Process.run("grep", ["a"], nil, false, false, x.output, STDOUT)
    end
  end
end
