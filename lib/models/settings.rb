require 'settingslogic'

class Settings < Settingslogic
  source "#{ Dir.pwd }/_config.yml"
end
