## Alfred

[![Gem Version](http://img.shields.io/gem/v/alfred_rails.svg)][gem]
[![Build Status](http://img.shields.io/travis/jhnvz/alfred.svg)][travis]
[![Coverage Status](http://img.shields.io/coveralls/jhnvz/alfred.svg)][coveralls]
[![Code Climate](http://img.shields.io/codeclimate/github/jhnvz/alfred.svg)][codeclimate]
[![Dependency Status](http://img.shields.io/gemnasium/jhnvz/alfred.svg)][gemnasium]

[gem]: https://rubygems.org/gems/alfred
[travis]: http://travis-ci.org/jhnvz/alfred
[coveralls]: https://coveralls.io/r/jhnvz/alfred
[codeclimate]: https://codeclimate.com/github/jhnvz/alfred
[gemnasium]: https://gemnasium.com/jhnvz/alfred

## Latest performance reports:

### Configuration:
```ruby
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

require "factory_girl"

Alfred.configure do |config|
  ## We detected the following libraries. Remove them if you don't want to use them.
  config.include Devise::TestHelpers
  config.include FactoryGirl::Syntax::Methods

  ## Setup
  config.setup do
    ## Runs before every scenario
    DatabaseCleaner.clean

    Apartment::Database.stub(:create).and_return(true)
    Apartment::Database.stub(:switch).and_return(true)
    Apartment::Database.stub(:drop).and_return(true)

    Api::ApplicationController.any_instance
      .stub(:current_company)
      .and_return(create(:company))
  end

  ## Mocking framework
  config.mock_with :rspec

  ## Fixture path
  config.fixture_path 'spec/javascripts/fixtures'
end
```

### Scenario
```ruby
Alfred.define do
  controller Api::V1::SessionsController do
    scenario "employee signed in" do
      setup do
        employee = create(:employee)
        sign_in :employee, employee
      end

      get :current, :format => :json
    end
  end
end
```

### Results

```
$ alfred

17:53:55 - INFO - Alfred: Serving all scenario's
1/1: |======================================================================================================================================================================================| Time: 00:00:00

17:53:56 - INFO - Alfred served the following fixtures:
/Users/Johan/Apps/ruby/booqable/spec/javascripts/fixtures/api/v1/sessions_controller/current/employee_signed_in.js


17:53:56 - INFO - MethodProfiler results for: Alfred
+----------------------+-----------+-----------+--------------+------------+-------------+
| Method               | Min Time  | Max Time  | Average Time | Total Time | Total Calls |
+----------------------+-----------+-----------+--------------+------------+-------------+
| .load!               | 29.675 ms | 29.675 ms | 29.675 ms    | 29.675 ms  | 1           |
| .load_configuration! | 16.940 ms | 16.940 ms | 16.940 ms    | 16.940 ms  | 1           |
| .configure           | 1.529 ms  | 1.529 ms  | 1.529 ms     | 1.529 ms   | 1           |
| .fixture_path        | 0.156 ms  | 0.173 ms  | 0.163 ms     | 0.488 ms   | 3           |
| .configuration       | 0.004 ms  | 0.445 ms  | 0.068 ms     | 0.476 ms   | 7           |
| .registry            | 0.003 ms  | 0.086 ms  | 0.045 ms     | 0.089 ms   | 2           |
+----------------------+-----------+-----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Configuration
+-----------------+----------+----------+--------------+------------+-------------+
| Method          | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-----------------+----------+----------+--------------+------------+-------------+
| #initialize     | 0.398 ms | 0.398 ms | 0.398 ms     | 0.398 ms   | 1           |
| #load_defaults! | 0.341 ms | 0.341 ms | 0.341 ms     | 0.341 ms   | 1           |
| #test_path      | 0.059 ms | 0.059 ms | 0.059 ms     | 0.059 ms   | 1           |
| #fixture_path   | 0.050 ms | 0.067 ms | 0.056 ms     | 0.225 ms   | 4           |
| #mock_with      | 0.050 ms | 0.051 ms | 0.051 ms     | 0.101 ms   | 2           |
| #setup          | 0.006 ms | 0.007 ms | 0.007 ms     | 0.013 ms   | 2           |
| #includes       | 0.005 ms | 0.005 ms | 0.005 ms     | 0.005 ms   | 1           |
| #include        | 0.004 ms | 0.006 ms | 0.005 ms     | 0.010 ms   | 2           |
| #rspec_defined? | 0.004 ms | 0.005 ms | 0.005 ms     | 0.009 ms   | 2           |
| #config         | 0.003 ms | 0.005 ms | 0.004 ms     | 0.025 ms   | 7           |
+-----------------+----------+----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Definition
+---------+-----------+-----------+--------------+------------+-------------+
| Method  | Min Time  | Max Time  | Average Time | Total Time | Total Calls |
+---------+-----------+-----------+--------------+------------+-------------+
| #define | 11.492 ms | 11.492 ms | 11.492 ms    | 11.492 ms  | 1           |
+---------+-----------+-----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::ScenarioDSL
+---------------------+----------+----------+--------------+------------+-------------+
| Method              | Min Time | Max Time | Average Time | Total Time | Total Calls |
+---------------------+----------+----------+--------------+------------+-------------+
| #get                | 0.328 ms | 0.328 ms | 0.328 ms     | 0.328 ms   | 1           |
| #setup_request_data | 0.281 ms | 0.281 ms | 0.281 ms     | 0.281 ms   | 1           |
| #setup              | 0.096 ms | 0.096 ms | 0.096 ms     | 0.096 ms   | 1           |
| #initialize         | 0.006 ms | 0.006 ms | 0.006 ms     | 0.006 ms   | 1           |
| #scenario           | 0.003 ms | 0.007 ms | 0.004 ms     | 0.017 ms   | 4           |
+---------------------+----------+----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Scenario
+------------------+------------+------------+--------------+------------+-------------+
| Method           | Min Time   | Max Time   | Average Time | Total Time | Total Calls |
+------------------+------------+------------+--------------+------------+-------------+
| #run             | 448.730 ms | 448.730 ms | 448.730 ms   | 448.730 ms | 1           |
| #perform_setup   | 385.452 ms | 385.452 ms | 385.452 ms   | 385.452 ms | 1           |
| #setup_request   | 41.864 ms  | 41.864 ms  | 41.864 ms    | 41.864 ms  | 1           |
| #perform_request | 18.704 ms  | 18.704 ms  | 18.704 ms    | 18.704 ms  | 1           |
| #file            | 0.004 ms   | 0.321 ms   | 0.163 ms     | 0.325 ms   | 2           |
| #controller_name | 0.099 ms   | 0.111 ms   | 0.105 ms     | 0.210 ms   | 2           |
| #initialize      | 0.022 ms   | 0.022 ms   | 0.022 ms     | 0.022 ms   | 1           |
| #name            | 0.004 ms   | 0.017 ms   | 0.010 ms     | 0.021 ms   | 2           |
| #params=         | 0.007 ms   | 0.007 ms   | 0.007 ms     | 0.007 ms   | 1           |
| #controller=     | 0.007 ms   | 0.007 ms   | 0.007 ms     | 0.007 ms   | 1           |
| #setups          | 0.004 ms   | 0.007 ms   | 0.005 ms     | 0.011 ms   | 2           |
| #method          | 0.005 ms   | 0.005 ms   | 0.005 ms     | 0.005 ms   | 1           |
| #controller      | 0.003 ms   | 0.007 ms   | 0.005 ms     | 0.018 ms   | 4           |
| #params          | 0.004 ms   | 0.004 ms   | 0.004 ms     | 0.004 ms   | 1           |
| #method=         | 0.004 ms   | 0.004 ms   | 0.004 ms     | 0.004 ms   | 1           |
| #action=         | 0.004 ms   | 0.004 ms   | 0.004 ms     | 0.004 ms   | 1           |
| #action          | 0.004 ms   | 0.004 ms   | 0.004 ms     | 0.008 ms   | 2           |
+------------------+------------+------------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::FixtureFile
+------------------+----------+----------+--------------+------------+-------------+
| Method           | Min Time | Max Time | Average Time | Total Time | Total Calls |
+------------------+----------+----------+--------------+------------+-------------+
| #save            | 2.076 ms | 2.076 ms | 2.076 ms     | 2.076 ms   | 1           |
| #to_js           | 0.683 ms | 0.683 ms | 0.683 ms     | 0.683 ms   | 1           |
| #filename        | 0.448 ms | 0.475 ms | 0.462 ms     | 0.923 ms   | 2           |
| #content         | 0.455 ms | 0.455 ms | 0.455 ms     | 0.455 ms   | 1           |
| #path            | 0.290 ms | 0.321 ms | 0.304 ms     | 0.913 ms   | 3           |
| #meta            | 0.208 ms | 0.208 ms | 0.208 ms     | 0.208 ms   | 1           |
| #initialize      | 0.007 ms | 0.007 ms | 0.007 ms     | 0.007 ms   | 1           |
| #response        | 0.004 ms | 0.018 ms | 0.007 ms     | 0.034 ms   | 5           |
| #controller_name | 0.004 ms | 0.013 ms | 0.006 ms     | 0.025 ms   | 4           |
| #action          | 0.003 ms | 0.004 ms | 0.004 ms     | 0.015 ms   | 4           |
| #name            | 0.003 ms | 0.004 ms | 0.003 ms     | 0.010 ms   | 3           |
+------------------+----------+----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Registry
+-------------+----------+----------+--------------+------------+-------------+
| Method      | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-------------+----------+----------+--------------+------------+-------------+
| #all        | 0.008 ms | 0.008 ms | 0.008 ms     | 0.008 ms   | 1           |
| #register   | 0.006 ms | 0.006 ms | 0.006 ms     | 0.006 ms   | 1           |
| #initialize | 0.005 ms | 0.005 ms | 0.005 ms     | 0.005 ms   | 1           |
+-------------+----------+----------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Request
+-----------------+-----------+------------+--------------+------------+-------------+
| Method          | Min Time  | Max Time   | Average Time | Total Time | Total Calls |
+-----------------+-----------+------------+--------------+------------+-------------+
| #_setup         | 22.129 ms | 363.004 ms | 192.566 ms   | 385.133 ms | 2           |
| #set_controller | 0.088 ms  | 0.088 ms   | 0.088 ms     | 0.088 ms   | 1           |
+-----------------+-----------+------------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::Runner
+----------------------------+------------+------------+--------------+------------+-------------+
| Method                     | Min Time   | Max Time   | Average Time | Total Time | Total Calls |
+----------------------------+------------+------------+--------------+------------+-------------+
| #initialize                | 450.956 ms | 450.956 ms | 450.956 ms   | 450.956 ms | 1           |
| #run                       | 450.660 ms | 450.660 ms | 450.660 ms   | 450.660 ms | 1           |
| #start_message             | 0.326 ms   | 0.326 ms   | 0.326 ms     | 0.326 ms   | 1           |
| #scenarios_for_controllers | 0.104 ms   | 0.104 ms   | 0.104 ms     | 0.104 ms   | 1           |
| #controllers_for_files     | 0.006 ms   | 0.006 ms   | 0.006 ms     | 0.006 ms   | 1           |
| #matches_for_controllers   | 0.005 ms   | 0.005 ms   | 0.005 ms     | 0.005 ms   | 1           |
+----------------------------+------------+------------+--------------+------------+-------------+

17:53:56 - INFO - MethodProfiler results for: Alfred::UI
+-------------+----------+----------+--------------+------------+-------------+
| Method      | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-------------+----------+----------+--------------+------------+-------------+
| .info       | 0.253 ms | 0.401 ms | 0.313 ms     | 3.131 ms   | 10          |
| #queue      | 0.009 ms | 0.110 ms | 0.075 ms     | 0.904 ms   | 12          |
| #display    | 0.020 ms | 0.071 ms | 0.039 ms     | 0.425 ms   | 11          |
| #timestamp  | 0.012 ms | 0.039 ms | 0.018 ms     | 0.198 ms   | 11          |
| #initialize | 0.004 ms | 0.007 ms | 0.005 ms     | 0.059 ms   | 11          |
+-------------+----------+----------+--------------+------------+-------------+
```
