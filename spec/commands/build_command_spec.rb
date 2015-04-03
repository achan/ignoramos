require 'fileutils'
require 'commands/build_command'
require 'commands/new_command'

RSpec.describe BuildCommand do
  describe '#execute' do
    let(:fixtures_dir) { 'spec/fixtures' }
    let(:test_dir) { "#{fixtures_dir}/test_site" }
    let(:expected_site_dir) { "#{fixtures_dir}/expected_generated_site" }
    let(:command) { BuildCommand.new(test_dir) }
    let(:settings) do
      Settingslogic.new('site' => { 'name' => 'My First Blog',
                                    'tagline' => 'Test tagline',
                                    'description' => '<p>Site description</p>',
                                    'user' => 'Test user',
                                    'site_map' => '',
                                    'post_limit' => 3 })
    end

    before do
      allow(Settings).to receive(:new).and_return(settings)

      command.execute
    end

    describe 'tag index' do
      it 'lists all posts ordered by tags' do
        contents = File.open("#{ test_dir }/_site/tags.html", 'r') do |file|
          file.read()
        end

        actual = File.open("#{ expected_site_dir }/tags.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)
      end
    end

    describe 'tag index per tag' do
      it 'lists all posts ordered alphabetically' do
        contents = File.open("#{ test_dir }/_site/tags/tag1.html", 'r') do |file|
          file.read()
        end


        actual = File.open("#{ expected_site_dir }/tags/tag1.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)

        contents = File.open("#{ test_dir }/_site/tags/tag2.html", 'r') do |file|
          file.read()
        end

        actual = File.open("#{ expected_site_dir }/tags/tag2.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)

        contents = File.open("#{ test_dir }/_site/tags/tag3.html", 'r') do |file|
          file.read()
        end

        actual = File.open("#{ expected_site_dir }/tags/tag3.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)
      end
    end

    describe 'home page' do
      it 'prints the configurable amount of posts in descending order' do
        contents = File.open("#{ test_dir }/_site/index.html", 'r') do |file|
          file.read()
        end

        actual = File.open("#{ expected_site_dir }/index.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)
      end
    end

    it 'drops rendered pages into the _site directory' do
      contents = File.open("#{ test_dir }/_site/first-page.html", 'r') do |file|
        file.read()
      end

      actual = File.open("#{ expected_site_dir }/first-page.html", 'r') do |file|
        file.read()
      end

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/custom-perm.html", 'r') do |file|
        file.read()
      end

      actual = File.open("#{ expected_site_dir }/custom-perm.html", 'r') do |file|
        file.read()
      end

      expect(contents).to eq(actual)
    end

    it 'drops rendered posts into the _site directory' do
      contents = File.open("#{ test_dir }/_site/2014/07/27/first-post.html", 'r') do |file|
        file.read()
      end

      actual = File.open("#{ expected_site_dir }/2014/07/27/first-post.html", 'r') do |file|
        file.read()
      end

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/2014/06/22/test-post.html", 'r') do |file|
        file.read()
      end

      actual = File.open("#{ expected_site_dir }/2014/06/22/test-post.html", 'r') do |file|
        file.read()
      end

      expect(contents).to eq(actual)
    end

    context 'custom files' do
      it 'copies all files not in _ folders into _site' do
        contents = File.open("#{ test_dir }/_site/rand/dir/test-post.html", 'r').
                        read

        actual = File.open("#{ expected_site_dir }/rand/dir/test-post.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)

        contents = File.open("#{ test_dir }/_site/testfile", 'r').read

        actual = File.open("#{ expected_site_dir }/testfile", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)
      end

      it 'overrides existing files' do
        contents = File.open("#{ test_dir }/_site/2014/06/22/another-test-post.html", 'r').
                        read

        actual = File.open("#{ expected_site_dir }/2014/06/22/another-test-post.html", 'r') do |file|
          file.read()
        end

        expect(contents).to eq(actual)
      end
    end
  end
end
