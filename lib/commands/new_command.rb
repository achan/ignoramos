class NewCommand
  attr_accessor :dir

  def initialize(dir)
    @dir = dir.to_s
  end
end
