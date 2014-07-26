require 'fileutils'

class NewCommand
  attr_accessor :dir

  def initialize(dir)
    @dir = dir.to_s
  end

  def execute
    FileUtils.mkdir_p([
      "#{ @dir }/_drafts",
      "#{ @dir }/_includes",
      "#{ @dir }/_layouts",
      "#{ @dir }/_posts",
      "#{ @dir }/_site"
    ])
  end
end
