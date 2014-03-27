## Robin Rails

[![Gem Version](https://badge.fury.io/rb/robin_rails.png)](http://badge.fury.io/rb/robin_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/robin_rails.png?branch=master)](http://travis-ci.org/jhnvz/robin_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/robin_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/robin_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/robin_rails.png)](https://codeclimate.com/github/jhnvz/robin_rails) [![Dependency Status](https://gemnasium.com/jhnvz/robin_rails.png)](https://gemnasium.com/jhnvz/robin_rails)

Robin Rails helps Batman fighting crime.

How it works
------------

Robin creates fixture files of your api responses so you can use them in your javascript tests.

Resources
------------

- [Installation](#installation)

Installation
------------

1. Add `gem 'robin_rails', '~> 1.0.0'` to your Gemfile.
1. Run `bundle install`.

Setting up scenario's
------------

```ruby
Robin.define do
  robin 'update post by manager' do
    setup do
      User.create(:name => 'John Doe', :permissions => { :manager => true })
      Post.create(:title => 'Robin is awesome', :body => 'It saves me time')
    end

    patch 'api/v1/posts#update', :id => 1, :post => { :title => 'Robin rocks!' }
  end
end
```

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

