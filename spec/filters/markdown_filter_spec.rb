require 'liquid'
require 'redcarpet'
require 'filters/markdown_filter'

RSpec.describe MarkdownFilter do
  before do
    Liquid::Template.register_filter(MarkdownFilter)
  end

  subject do
    Liquid::Template.parse("{{ '**markdown**' | markdownToHtml }}").render
  end

  it { is_expected.to eq("<p><strong>markdown</strong></p>") }
end
