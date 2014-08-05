require 'models/post'

class Page < Post
  def permalink
    if vars.has_key?('permalink')
      normalize_custom_permalink
    else
      "/#{ slug }.html"
    end
  end
end
