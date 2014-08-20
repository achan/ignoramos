require 'models/app_config'

RSpec.describe AppConfig do
  context 'Configuration set' do
    let(:content) do
      <<-CONTENT
---
site:
  description: this is **awesome**
  user: Test User
  site_map: >
    [hello][h]

    [h]: http://hello.world
CONTENT
    end

    let(:config) { AppConfig.new(content) }

    describe '#site_map' do
      it 'returns site map in html' do
        expect(config.site_map).to eq('<p><a href="http://hello.world">hello</a></p>')
      end
    end

    describe '#site_description' do
      it 'returns site description in html' do
        expect(config.site_description).to eq('<p>this is <strong>awesome</strong></p>')
      end
    end

    describe '#user' do
      it 'returns user name' do
        expect(config.user).to eq('Test User')
      end
    end
  end

  context 'Configuration not set' do
    let(:content) do
      <<-CONTENT
---
CONTENT
    end

    let(:config) { AppConfig.new(content) }

    describe '#site_map' do
      it 'returns empty string' do
        expect(config.site_map).to eq('')
      end
    end

    describe '#site_description' do
      it 'returns empty string' do
        expect(config.site_description).to eq('')
      end
    end

    describe '#user' do
      it 'returns empty string' do
        expect(config.user).to eq('')
      end
    end
  end
end
