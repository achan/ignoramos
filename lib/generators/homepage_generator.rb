require 'liquid'
require 'models/settings'

class HomepageGenerator
  def initialize(posts, file_helper)
    @posts = posts
    @file_helper = file_helper
  end

  def generate
    @file_helper.new_file("_site/index.html",
                          Liquid::Template.parse(template).render({
                            'posts' => homepage_posts,
                            'title' => "#{Settings.site.name} - #{Settings.site.tagline}",
                            'site' => Settings.site.to_hash
                          }))
  end

  private
  def homepage_posts
    @homepage_posts ||= @posts.sort_by { |p| [p.published_at.to_i, p.title] }.
                               reverse.
                               first(Settings.site['post_limit'] || 5)
  end

  def template 
    @template ||= @file_helper.read_file("_layouts/default/posts.liquid")
  end
end
