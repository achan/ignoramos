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
      "#{ @dir }/_pages",
      "#{ @dir }/_posts",
      "#{ @dir }/_site"
    ])

    blog_name = 'My First Blog'
    tagline = 'A short description of my blog'
    desc = 'Site description'

    new_file("_config.yml",
             "---\nsite:\n  name: #{ blog_name }\n  tagline: #{ tagline }\n  description: #{ desc }")
  end

  private
  def new_file(filename, contents)
    new_post_file = File.new("#{ @dir }/#{ filename }", 'w')
    new_post_file.write(contents)
    new_post_file.close
  end
end
