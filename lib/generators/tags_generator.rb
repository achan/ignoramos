require 'liquid'
require 'models/settings'

class TagsGenerator
  attr_reader :tags

  def initialize(tags, file_helper)
    @tags = tags
    @file_helper = file_helper
  end

  def generate
    new_tags_index_file("_site/tags.html",
                        "Tag Index - #{Settings.site.name}",
                        tags)

    generate_index_per_tag
  end

  private
  def new_tags_index_file(filename, title, tags)
    @file_helper.new_file(filename,
             Liquid::Template.parse(tags_layout).render({
               'title' => title,
               'tags' => tags,
               'site' => Settings.site.to_hash
             }))
  end

  def generate_index_per_tag
    @file_helper.mkdir_p("_site/tags")

    tags.each do |tag|
      new_tags_index_file("_site/tags/#{ tag['name'] }.html",
                          "##{ tag['name'] } - #{Settings.site.name}",
                          [tag])
    end
  end

  def tags_layout
    @layout ||= @file_helper.read_file("_layouts/default/tags.liquid")
  end
end
