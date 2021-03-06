require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(99)
end

require 'my_mongoid'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def prepare_database
  before(:all) do
    MyMongoid.configure do |config|
      config.host = "localhost:27017"
      config.database = "my_mongoid"
    end
  end
  after(:all) do
    MyMongoid.configure do |config|
      config.host = nil
      config.database = nil
    end
  end
end
