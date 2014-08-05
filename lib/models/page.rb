require 'models/post'

class Page < Post
  def permalink
    if vars.has_key?('permalink')
      normalize_custom_permalink
    else
      "/#{ slug }.html"
    end
  end

  private
  def normalize_custom_permalink
    permalink = @vars['permalink']
    if permalink[0] == '/'
      return permalink
    else
      return "/#{ permalink }"
    end
  end
end
