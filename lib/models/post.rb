require 'yaml'
require 'liquid'
require 'redcarpet'
require 'time'

class Post
  attr_accessor :content
  attr_accessor :vars

  DEFAULT_VARS = {
    'layout' => 'default',
    'markup' => 'ext',
    'timestamp' => DateTime.now
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

  def slug
    "#{ path }/#{ @vars['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') }"
  end

  def path
    return @vars['permalink'] if @vars.has_key?('permalink')
    "/#{ date.year }/#{ date.month.to_s.rjust(2, '0') }/#{ date.day.to_s.rjust(2, '0') }"
  end

  private
  def date
    @date ||= timestamp.to_date
  end

  def timestamp
    @timestamp ||= @vars['timestamp']
  end

  def markdown_to_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).
                        render(@content).
                        strip
  end
end
