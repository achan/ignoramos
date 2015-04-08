module MarkdownFilter
  def markdownToHtml(input)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(input).strip
  end
end
