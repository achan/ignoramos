require 'liquid'

class BuildCommand
  def execute
    html = Liquid::Template.parse('header {{post}} footer').
                            render('post' => 'this is my post')

    File.open('testpost.html', 'w') { |file| file.write(html) }
  end
end
