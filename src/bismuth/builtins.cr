module Bismuth::Builtins
  # Change the current directory for the bismuth process. 
  def cd(dir : String)
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
end
