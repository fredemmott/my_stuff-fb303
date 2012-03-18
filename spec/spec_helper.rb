unless RUBY_VERSION.start_with? '1.8.'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/gen-rb/'
  end
end

RSpec.configure do |c|
  # declare an exclusion filter
  c.filter_run_excluding :broken => true
end

load File.expand_path('../examples/server', File.dirname(__FILE__))
