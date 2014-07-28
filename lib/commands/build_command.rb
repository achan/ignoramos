require 'liquid'
require 'fileutils'
require './lib/models/post'

class BuildCommand
  def execute
    # File.open('testpost.html', 'w') { |file| file.write(html) }
    FileUtils.rm_rf('spec/commands/testsite/_site/posts')
    FileUtils.mkdir_p('spec/commands/testsite/_site/posts')

    Dir.foreach('spec/commands/testsite/_posts') do |item|
      next if item == '.' || item == '..'

      filename = item.slice(0, item.rindex('.'))

      contents = File.open("spec/commands/testsite/_posts/#{ item }", 'r') do |file|
        file.read()
      end

      new_post = File.new("spec/commands/testsite/_site/posts/#{ filename }.html", 'w')
      new_post.write(Post.new(contents).render)
      new_post.close
    end
  end
end
