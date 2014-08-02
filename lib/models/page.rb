require 'models/post'

class Page < Post
  def permalink
    return @vars['permalink'] if @vars.has_key?('permalink')
    "/#{slug}"
  end
end
