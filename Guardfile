guard 'rspec', cmd: 'bundle exec rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/commands/(.+)\.rb$})     { |m| "spec/commands/#{m[1]}_spec.rb" }
  watch(%r{^lib/models/(.+)\.rb$})     { |m| "spec/models/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

