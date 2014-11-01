require 'liquid'
require 'file_helper'
require 'models/settings'

class PostGenerator
  attr_reader :post, :template, :post_params

  def initialize(post, template, post_params, file_helper)
    @post = post
    @template = template
    @post_params = post_params
    @file_helper = file_helper
  end

  def generate
    @file_helper.mkdir_p("_site#{ post.path }")
    @file_helper.new_file("_site#{ post.permalink }",
                          Liquid::Template.parse(layout_template).
                                           render(full_page_params))
  end

  private
  def layout_template
    @layout_template ||=
        @file_helper.read_file("_layouts/#{post.vars['layout']}/#{template}.liquid")
  end

  def full_page_params
    full_params = { 'site' => Settings.site.to_hash }.merge(post_params.merge(post.vars))
    full_params['title'] = "#{full_params['title']} - #{Settings.site.name}"
    full_params
  end
end
