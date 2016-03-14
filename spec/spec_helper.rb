require 'bundler/setup'
Bundler.setup

require 'rails/all'
require 'fetch-process-multi'

RSpec.configure do |config|
  config.before do
    Rails.instance_variable_set(:@cache, ActiveSupport::Cache::MemoryStore.new)
  end
end
