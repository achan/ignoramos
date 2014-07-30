require 'yaml'
require 'liquid'
require 'redcarpet'

class Post
  attr_accessor :content
  attr_accessor :vars

  DEFAULT_VARS = {
    'layout' => 'default',
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
    Liquid::Template.parse(markdown_to_html).render(@vars)
  end

  private
  def markdown_to_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).
                        render(@content).
                        strip
  end
end
