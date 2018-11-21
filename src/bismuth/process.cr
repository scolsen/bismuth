module Bismuth::Dispatch
  def run(command : String, args : Array(String))
    Process.run(command, args, nil, false, false, STDIN, STDOUT, STDERR)
  end
end
