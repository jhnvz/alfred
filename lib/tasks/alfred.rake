task :alfred do
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

  ## Run all examples
  Alfred::Runner.new
end
