class Ignoramos
  def initialize(args = [])
    command(args).execute
  end

  NilCommand = Struct.new(:args) do
    def execute
      puts 'command not supported'
    end
  end

  private
  def command(args)
    cmd = args.slice!(0) unless args.empty?
    Object.const_get(classify(cmd)).new(*args)
  rescue NameError
    NilCommand.new
  end


  def classify(command)
    snake_class = "#{command}_command"
    begin
      require "commands/#{snake_class}"
    rescue LoadError => e
      puts e.to_s
    end
    puts snake_class.split('_').collect(&:capitalize).join
    snake_class.split('_').collect(&:capitalize).join
  end
end
