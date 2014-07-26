require 'commands/new_command'

class Ignoramos
  def initialize(args = [])
    command(args).execute
  end

  def command(args)
    cmd = args[0] unless args.empty?

    if cmd == 'new'
      NewCommand.new(args[1])
    else
      NilCommand.new
    end
  end

  NilCommand = Struct.new(:args) do
    def execute
    end
  end
end
