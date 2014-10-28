require 'fileutils'
require 'file_helper'

class NewCommand
  attr_accessor :dir

  def initialize(dir)
    @dir = dir.to_s
    @file_helper = FileHelper.new(dir)
  end

  def execute
    FileUtils.mkdir_p([
      "#{ @dir }/_drafts",
      "#{ @dir }/_includes",
      "#{ @dir }/_layouts",
      "#{ @dir }/_pages",
      "#{ @dir }/_posts",
      "#{ @dir }/_site"
    ])

    blog_name = 'My First Blog'
    tagline = 'A short description of my blog'
    desc = 'Site description'

    @file_helper.new_file("_config.yml",
                          "---\nsite:\n  name: #{ blog_name }\n  tagline: #{ tagline }\n  description: #{ desc }")
  end
end
