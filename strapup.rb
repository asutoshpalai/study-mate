ROOT_PATH = File.expand_path(File.dirname(__FILE__))
Dir.glob(ROOT_PATH + '/db/*.rb').each {|file| require file}
require_relative 'auth/auth'
require_relative 'base'
Dir.glob(ROOT_PATH + '/controllers/*.rb').each {|file| require file}
Dir.glob(ROOT_PATH + '/helpers/*.rb').each do |file| 
  require file
  Base.helpers Object.const_get(File.basename(file, '.rb').capitalize + 'Helpers')

end
