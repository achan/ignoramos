require 'commands/new_command'
require 'commands/build_command'
require 'commands/tweet_command'

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
    "#{command}_command".split('_').collect(&:capitalize).join
  end
end
