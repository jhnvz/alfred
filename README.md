------------
:warning: **This repository is still under development** :warning:

------------


## Alfred Rails

[![Gem Version](https://badge.fury.io/rb/alfred_rails.png)](http://badge.fury.io/rb/alfred_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/alfred_rails.png?branch=master)](http://travis-ci.org/jhnvz/alfred_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/alfred_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/alfred_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/alfred_rails.png)](https://codeclimate.com/github/jhnvz/alfred_rails) [![Dependency Status](https://gemnasium.com/jhnvz/alfred_rails.png)](https://gemnasium.com/jhnvz/alfred_rails)

Serves controller action responses under several conditions.

How it works
------------

Alfred creates fixture files of your controller responses so you can use them in your tests. Ideal if your app's client is build with a javascript framework and you want to test responses under several conditions.

Resources
------------

- [Installation](#installation)
- [Defining scenario's](#defining-scenarios)
- [Configuration](#configuration)
- [Javascript testing](#javascript-testing)
- [Guard](#guard)

Installation
------------

1. Add `gem 'alfred_rails', '~> 1.0.0'` to your Gemfile (inside test group).
2. Run `bundle install`.
3. Run `rails g alfred:install`.

Defining scenario's
------------

You can create empty definitions by running: 
```
$ rails g alfred:controller api/v1/posts
```

Here's an example of a definition:
```ruby
# spec/alfreds/api/v1/posts_controller.rb

Alfred.define do
  setup do
    sign_in :user, create(:user)
  end

  controller Api::V1::PostsController do
    scenario 'update post by manager' do
      setup do
        create(:post, :title => 'Alfred is awesome', :body => 'It saves me time')
      end

      patch :update, {
        :format => :json,
        :id     => 1,
        :post   => {
          :title => 'Alfred rocks!'
        }
      }
    end
  end

  scenario 'update post by manager' do
    controller Api::V1::PostsController
  end
end
```

This will create a fixture file which you can use in your javascript tests at:
```
spec/javascripts/fixtures/api/v1/posts/update/update_by_manager.js
```

Configuration
------------

```ruby
# spec/alfred_helper.rb

Alfred.configure do |config|
  ## Includes
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers

  ## Setup
  config.setup do
    Apartment::Database.stub(:create).and_return(true)
  end
  
  ## Mocking framework
  config.mock_with :rspec
  
  ## Fixture path
  config.fixture_path 'spec/javascripts/fixtures'
end
```

Configuration instructions

Javascript testing
------------

After defining and generating Alfred fixtures they are accessible in your JavaScript tests.

```coffeescript
# Get request response
Alfred.serve('posts_controller/update', 'update post by manager')

# Example of a test
describe 'PostModel', ->

  describe '#update', ->

    it 'should update model', ->
      response  = Alfred.serve('posts_controller/update', 'update post by manager')
      @server   = sinon.fakeServer.create()

      @server.respondWith 'PATCH', 'posts/1', [200, { 'Content-Type': 'application/json' }, response]

      @post.update()
      @server.respond()

      @post.updated().should.equal(true)
```

Implementation on this differs on which libraries you are using to test with. In the above example we're using SinonJS to create a fake server response.

### SinonJS adapter

```coffeescript
# Creates fake server and calls respondWith
Alfred.SinonAdapter.serve('posts_controller/update', 'update post by manager')

# Example of a test
describe 'PostModel', ->

  describe '#update', ->

    it 'should update model', ->
      @server = Alfred.SinonAdapter.serve('posts_controller/update', 'update post by manager')

      @post.update()
      @server.respond()

      @post.updated().should.equal(true)
```

### Using any other test adapter

By calling `Alfred.fetch` you can fetch a scenario object with meta data, such as path, request method etc. This can be useful when stubbing a request;

```coffeescript
Alfred.fetch('posts/update', 'update post by manager') # => Object
```

Guard
------------

Add the gem to your Gemfile (inside development group):
``` ruby
 gem 'guard-alfred', :require => false
```

Add guard definition to your Guardfile by running this command:
```
$ guard init alfred
```

Make sure to put this block on top of your Guardfile so all fixtures are created before running tests.
```ruby
guard :alfred do
  watch(%r{^app/controllers/(.+)\.rb$}) { |m| "spec/alfreds/#{m[1]}.rb" }
  watch(%r{^spec/alfreds/(.+)\.rb$})    { |m| "spec/alfreds/#{m[1]}.rb" }
end
```

Supported Ruby Versions
------------

This library is tested against Travis and aims to support the following Ruby
implementations:

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

