task :robin do
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

  ## Run all examples


  RobinRails.registry.each { |robin| robin.run }
end
