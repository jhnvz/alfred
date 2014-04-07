------------
:warning: **This repository is still under development** :warning:

------------


## Robin Rails

[![Gem Version](https://badge.fury.io/rb/robin_rails.png)](http://badge.fury.io/rb/robin_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/robin_rails.png?branch=master)](http://travis-ci.org/jhnvz/robin_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/robin_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/robin_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/robin_rails.png)](https://codeclimate.com/github/jhnvz/robin_rails) [![Dependency Status](https://gemnasium.com/jhnvz/robin_rails.png)](https://gemnasium.com/jhnvz/robin_rails)

Robin Rails helps Batman fighting crime.

How it works
------------

Robin creates fixture files of your api responses so you can use them in your tests. Ideal if your app's client is build with a javascript framework and you want to test responses under several conditions.

Resources
------------

- [Installation](#installation)
- [Defining scenario's](#defining-scenarios)
- [Configuration](#configuration)
- [Javascript testing](#javascript-testing)
- [Guard](#guard)

Installation
------------

1. Add `gem 'robin_rails', '~> 1.0.0'` to your Gemfile.
1. Run `bundle install`.

Defining scenario's
------------

For example:

```ruby
# spec/robins/api/v1/posts_controller.rb

Robin.define do
  setup do
    sign_in :user, create(:user)
  end

  controller Api::V1::PostsController do
    scenario 'update post by manager' do
      setup do
        create(:poset, :title => 'Robin is awesome', :body => 'It saves me time')
      end

      patch :update, {
        :format => :json,
        :id     => 1,
        :post   => {
          :title => 'Robin rocks!'
        }
      }
    end
  end

  scenario 'update post by manager' do
    controller Api::V1::PostsController
  end
end
```
Will create `spec/fixtures/api/v1/posts/update/update_by_manager.json`

Configuration
------------

```ruby
# spec/robin_configuration.rb

Robin.configure do |c|
  ## Includes
  config.include FactoryGirl::Syntax::Methods, :controller
  config.include Devise::TestHelpers, :controller

  ## Before
  config.before do
    Apartment::Database.stub(:create).and_return(true)
  end
  
  ## Mocking framework
  config.mock_with :rspec
end
```

Configuration instructions

Javascript testing
------------

Javascript testing instructions

Guard
------------

```ruby
guard :robin do
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| "spec/robins/#{m[1]}_#{m[2]}.rb" }
  watch(%r{^spec/robins/(.+)\.rb$}) { |m| "spec/robins/#{m[1]}.rb" }
end
```

Here goes the instruction to setup Robin with Guard.

Supported Ruby Versions
------------

This library is tested against Travis and aims to support the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.1

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright
------------

Copyright (c) 2014 Johan van Zonneveld. See LICENSE for details.

