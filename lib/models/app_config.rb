require 'yaml'
require 'redcarpet'

class AppConfig
  attr_accessor :vars

  def initialize(content)
    @vars = YAML::load(content)
    @vars = {} if @vars.nil?
  end

  def site_description
    @site_description ||= html(site.fetch('description', ''))
  end

  def site_map
    @site_map ||= html(site.fetch('site_map', ''))
  end

  def user
    @user ||= site.fetch('user', '')
  end

  private
  def site
    @site ||= vars.fetch('site', {})
  end

  def html(markdown)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown).strip
  end
end
