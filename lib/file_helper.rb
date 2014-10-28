require 'fileutils'

class FileHelper
  attr_reader :dir

  def initialize(dir)
    @dir = dir
  end

  def new_file(filename, contents)
    new_post_file = File.new("#{dir}/#{filename}", 'w')
    new_post_file.write(contents)
    new_post_file.close
  end

  def read_file(filename)
    File.open("#{dir}/#{filename}", 'r') do |file|
      file.read()
    end
  end

  def mkdir_p(dir)
    FileUtils.mkdir_p("#{@dir}/#{dir}")
  end
end
