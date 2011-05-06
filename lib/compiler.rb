class Compiler
  MODULE_NAMES = ['CMouse']

  # makes all modules, returns false if any of them
  # fail, true otherwise
  def self.make_all
    ! (MODULE_NAMES.map do |module_name|
      make module_name
    end.member? false)
  end

  # makes a single module
  def self.make module_name
    commands = [ 
      "ruby extconf.rb;",
      "make clean;",
      "make;",
      "cd #{File.dirname(__FILE__)};",
    ]

    error = commands.find do |command| 
      cd = "cd #{File.dirname(__FILE__)}/#{module_name} "
      system("#{cd} ; #{command}") == false
    end

    error.nil?
  end

end

