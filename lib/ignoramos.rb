require 'commands/new_command'
require 'commands/build_command'
require 'commands/tweet_command'

class Ignoramos
  def initialize(args = [])
    command(args).execute
  end

  def command(args)
    cmd = args[0] unless args.empty?

    if cmd == 'new'
      NewCommand.new(args[1])
    elsif cmd == 'build'
      BuildCommand.new
    elsif cmd == 'tweet'
      TweetCommand.new(args[1])
    else
      NilCommand.new
    end
  end

  NilCommand = Struct.new(:args) do
    def execute
      puts 'command not supported'
    end
  end
end
