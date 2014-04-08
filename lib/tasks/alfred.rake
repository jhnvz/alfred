task :alfred do
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'test'

  ## Run all examples
  Bundler.with_clean_env { Kernel.system('bundle exec alfred') }
end
