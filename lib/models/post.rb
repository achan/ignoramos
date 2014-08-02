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

  def permalink
    return @vars['permalink'] if @vars.has_key?('permalink')
    "#{ path }/#{ slug }"
  end

  def slug
    @slug ||= @vars['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def path
    @path ||= "/#{ date.year }/#{ date.month.to_s.rjust(2, '0') }/#{ date.day.to_s.rjust(2, '0') }"
  end

  def html
    @html ||= Liquid::Template.parse(markdown_to_html).render(@vars)
  end

  def timestamp
    @timestamp ||= @vars['timestamp']
  end

  def title
    @title ||= @vars['title']
  end

  def tags
    @tags ||= @vars['tags'].split(',').map { |x| x.strip }.sort
  end

  def to_liquid
    {
      'html' => html,
      'title' => title
    }
  end

  private
  def strip_yaml(text)
    text.to_s.gsub(/---(.|\n)*---/, '').strip
  end

  def date
    @date ||= timestamp.to_date
  end

  def markdown_to_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).
                        render(@content).
                        strip
  end
end
