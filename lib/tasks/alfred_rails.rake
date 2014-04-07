task :alfred do
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

  ## Run all examples


  Alfred.registry.each { |alfred| alfred.run }
end
