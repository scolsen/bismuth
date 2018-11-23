module Bismuth::Pipeline
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
