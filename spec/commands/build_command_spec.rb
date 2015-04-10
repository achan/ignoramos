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
                                    'description' => 'Site description',
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
        expect(FileUtils.compare_file("#{ test_dir }/_site/tags.html",
                                      "#{ expected_site_dir }/tags.html")).to be_truthy
      end
    end

    describe 'tag index per tag' do
      it 'lists all posts ordered alphabetically' do
        expect(FileUtils.compare_file("#{ test_dir }/_site/tags/tag1.html",
                                      "#{ expected_site_dir }/tags/tag1.html")).to be_truthy

        expect(FileUtils.compare_file("#{ test_dir }/_site/tags/tag2.html",
                                      "#{ expected_site_dir }/tags/tag2.html")).to be_truthy

        expect(FileUtils.compare_file("#{ test_dir }/_site/tags/tag3.html",
                                      "#{ expected_site_dir }/tags/tag3.html")).to be_truthy
      end
    end

    describe 'home page' do
      it 'prints the configurable amount of posts in descending order' do
        expect(FileUtils.compare_file("#{ test_dir }/_site/index.html",
                                      "#{ expected_site_dir }/index.html")).to be_truthy
      end
    end

    it 'drops rendered pages into the _site directory' do
      expect(FileUtils.compare_file("#{ test_dir }/_site/first-page.html",
                                    "#{ expected_site_dir }/first-page.html")).to be_truthy


      expect(FileUtils.compare_file("#{ test_dir }/_site/custom-perm.html",
                                    "#{ expected_site_dir }/custom-perm.html")).to be_truthy
    end

    it 'drops rendered posts into the _site directory' do
      expect(FileUtils.compare_file("#{ test_dir }/_site/2014/07/27/first-post.html",
                                    "#{ expected_site_dir }/2014/07/27/first-post.html")).to be_truthy

      expect(FileUtils.compare_file("#{ test_dir }/_site/2014/06/22/test-post.html",
                                    "#{ expected_site_dir }/2014/06/22/test-post.html")).to be_truthy
    end

    context 'custom files' do
      it 'copies all files not in _ folders into _site' do
        expect(FileUtils.compare_file("#{ test_dir }/_site/rand/dir/test-post.html",
                                      "#{ expected_site_dir }/rand/dir/test-post.html")).to be_truthy

        expect(FileUtils.compare_file("#{ test_dir }/_site/testfile",
                                      "#{ expected_site_dir }/testfile")).to be_truthy
      end

      it 'overrides existing files' do
        expect(FileUtils.compare_file("#{ test_dir }/_site/2014/06/22/another-test-post.html",
                                      "#{ expected_site_dir }/2014/06/22/another-test-post.html")).to be_truthy
      end
    end
  end
end
