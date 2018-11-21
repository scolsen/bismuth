module Bismuth::Types
  alias Args     = Array(String)
  alias Command  = Tuple(String, Args | Nil)
  alias Commands = Array(Command) 
end
