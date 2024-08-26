# require 'chefspec'
# require 'chefspec/policyfile'

# # Carga el archivo custom_matchers.rb
# Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }


require 'chefspec'
require 'chefspec/policyfile'

# Configuración general para ChefSpec
RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '20.04'
end

# Carga archivos personalizados de matchers, helpers, etc.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }


