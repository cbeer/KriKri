require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl_rails'

require 'dpla/map/factories'
require 'rdf/marmotta'

require 'devise'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

WebMock.disable_net_connect!(:allow_localhost => true)

RSpec.configure do |config|
  config.color = true
  config.formatter = :progress
  config.mock_with :rspec

  config.include FactoryGirl::Syntax::Methods

  # These are for ensuring that controller tests are authenticated:
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller

  # use_transactional_fixtures is false to comply with database cleaner configs
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  def clear_repository
    Krikri::Repository.clear!
  end

  config.before(:suite) do
    clear_repository
  end

  config.after(:suite) do
    clear_repository
    WebMock.disable_net_connect!(:allow => 'codeclimate.com')
  end
end
