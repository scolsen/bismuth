module Bismuth::Pipeline
  abstract class Coupling
    getter source, dest
    setter origin

    def initialize()
      @source, @dest = IO.pipe
    end

    def connect(coupling : Coupling)
      plunge(input: @origin, output: @dest)
      @dest.close
      coupling.origin = @source
    end

    abstract def plunge(input : IO::FileDescriptor, output : IO::FileDescriptor)
    end
  end
 
  class ProcessCoupling < Coupling
    def initialize(command : Command)
      super
      @command   = command[0]
      @arguments = command[1]
    end
    
    def plunge(input : IO::FileDescriptor, output : IO::FileDescriptor)
      Process.run(@command, @arguments, input: input, output: output)
    end
  end

  class BuiltinCoupling < Coupling
    def initialize(command : Command)
      super
      @command   = command[0]
      @arguments = command[1]
    end

    def plunge(input, output)
      Builtins.run(@command, @arguments, input: input, output: output)
    end
  end

  class Pipeline
    getter endpoint 
    
    def initialize(@endpoint : IO::FileDescriptor, @commands : Commands)
    end

    def run
      @commands.each do | command |
        r, w = IO.pipe
        Process.run(command[0], command[1], input: @endpoint, output: w)
        w.close
        @endpoint = r
      end
    end
  end
end
