require 'coveralls'
Coveralls.wear!
require 'trakio'
require 'webmock/rspec'
require 'json'
require 'pry'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/date/calculations'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.color = true
  config.formatter = "Fuubar"
  config.filter_run_excluding :wip => true
end