require 'rubygems'
require 'rake/dsl_definition'
require 'rake'
require 'rspec/core/rake_task'

THRIFT_SOURCES = [
  'echo',
  'fb303',
]

task :thrift => THRIFT_SOURCES.map{|x| "gen-rb/#{x}_types.rb"} do
end

THRIFT_SOURCES.each do |name|
  file "gen-rb/#{name}_types.rb" => "examples/#{name}.thrift" do
    sh "thrift --gen rb examples/#{name}.thrift"
  end
end

RSpec::Core::RakeTask.new(:spec)
task :spec => :thrift
task :test => :spec
task :default => :test
