require 'yaml'
require 'liquid'

class Post
  attr_accessor :content
  attr_accessor :vars

  DEFAULT_VARS = {
    'layout' => 'post',
    'markup' => 'ext'
  }

  def initialize(content)
    @content = strip_yaml(content)
    @vars = DEFAULT_VARS.merge(YAML::load(content))
  end

  def strip_yaml(text)
    text.to_s.gsub(/---(.|\n)*---/, '').strip
  end

  def render
    Liquid::Template.parse(@content).render(@vars)
  end
end
