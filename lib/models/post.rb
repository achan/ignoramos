require 'yaml'
require 'liquid'
require 'redcarpet'
require 'time'
require 'rouge'
require 'rouge/plugins/redcarpet'

class Post
  attr_reader :content
  attr_reader :vars

  DEFAULT_VARS = {
    "layout" => "default",
    "markup" => "ext",
    "timestamp" => DateTime.now,
    "tags" => ""
  }

  def initialize(content)
    @content = strip_yaml(content)
    @vars = DEFAULT_VARS.merge(YAML::load(content) || {})
  end

  def permalink
    if @vars.has_key?('permalink')
      "#{ path }/#{ normalize_custom_permalink }.html"
    else
      "#{ path }/#{ slug }.html"
    end
  end

  def slug
    return '' unless @vars['title']
    @vars['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def path
    display_year = published_at.year
    display_month = published_at.month.to_s.rjust(2, '0')
    display_day = published_at.day.to_s.rjust(2, '0')

    "/#{display_year}/#{display_month}/#{display_day}"
  end

  def html
    @html ||= Liquid::Template.parse(markdown_to_html).render(@vars)
  end

  def published_at
    @vars['timestamp']
  end

  def title
    @vars['title']
  end

  def tags
    @tags ||= @vars['tags'].split(',').map(&:strip).sort
  end

  def external_link
    vars['external_link']
  end

  def title_link
    external_link || permalink
  end

  def post_type
    has_external_link? ? :link_post : :self_post
  end

  def to_liquid
    {
      "external_link" => external_link,
      "html" => html,
      "permalink" => permalink,
      "post_type" => post_type.to_s,
      "slug" => slug,
      "tags" => tags,
      "timestamp" => published_at.iso8601,
      "title" => title,
      "title_link" => title_link
    }
  end

  protected

  def normalize_custom_permalink
    permalink = @vars['permalink']
    if permalink[0] == '/'
      return permalink[1..-1]
    else
      return permalink
    end
  end

  private

  def has_external_link?
    !external_link.nil?
  end

  def strip_yaml(text)
    text.to_s.gsub(/---(.|\n)*---/, '').strip
  end

  def markdown_to_html
    Redcarpet::Markdown.
      new(Redcarpet::Render::HTML).
      render(content).
      strip
  end

  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
