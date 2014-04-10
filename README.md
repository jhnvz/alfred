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

100 times:

```
18:05:59 - INFO - Alfred: Serving all scenario's
100/100: |==================================================================================================================================================================================| Time: 00:00:04

18:06:03 - INFO - MethodProfiler results for: Alfred
+----------------------+------------+------------+--------------+------------+-------------+
| Method               | Min Time   | Max Time   | Average Time | Total Time | Total Calls |
+----------------------+------------+------------+--------------+------------+-------------+
| .load!               | 128.738 ms | 128.738 ms | 128.738 ms   | 128.738 ms | 1           |
| .load_configuration! | 16.752 ms  | 16.752 ms  | 16.752 ms    | 16.752 ms  | 1           |
| .configure           | 1.527 ms   | 1.527 ms   | 1.527 ms     | 1.527 ms   | 1           |
| .fixture_path        | 0.133 ms   | 0.578 ms   | 0.174 ms     | 52.052 ms  | 300         |
| .configuration       | 0.003 ms   | 0.457 ms   | 0.005 ms     | 2.645 ms   | 502         |
| .registry            | 0.003 ms   | 0.063 ms   | 0.005 ms     | 0.481 ms   | 101         |
+----------------------+------------+------------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Configuration
+-----------------+----------+----------+--------------+------------+-------------+
| Method          | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-----------------+----------+----------+--------------+------------+-------------+
| #initialize     | 0.406 ms | 0.406 ms | 0.406 ms     | 0.406 ms   | 1           |
| #load_defaults! | 0.349 ms | 0.349 ms | 0.349 ms     | 0.349 ms   | 1           |
| #fixture_path   | 0.046 ms | 0.286 ms | 0.061 ms     | 18.434 ms  | 301         |
| #mock_with      | 0.046 ms | 0.178 ms | 0.060 ms     | 6.015 ms   | 101         |
| #test_path      | 0.058 ms | 0.058 ms | 0.058 ms     | 0.058 ms   | 1           |
| #includes       | 0.006 ms | 0.006 ms | 0.006 ms     | 0.006 ms   | 1           |
| #setup          | 0.004 ms | 0.029 ms | 0.006 ms     | 0.564 ms   | 101         |
| #include        | 0.004 ms | 0.006 ms | 0.005 ms     | 0.010 ms   | 2           |
| #config         | 0.003 ms | 0.128 ms | 0.005 ms     | 2.013 ms   | 403         |
| #rspec_defined? | 0.004 ms | 0.005 ms | 0.005 ms     | 0.009 ms   | 2           |
+-----------------+----------+----------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Definition
+---------+------------+------------+--------------+------------+-------------+
| Method  | Min Time   | Max Time   | Average Time | Total Time | Total Calls |
+---------+------------+------------+--------------+------------+-------------+
| #define | 110.574 ms | 110.574 ms | 110.574 ms   | 110.574 ms | 1           |
+---------+------------+------------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::ScenarioDSL
+---------------------+----------+----------+--------------+------------+-------------+
| Method              | Min Time | Max Time | Average Time | Total Time | Total Calls |
+---------------------+----------+----------+--------------+------------+-------------+
| #get                | 0.316 ms | 5.928 ms | 0.404 ms     | 40.377 ms  | 100         |
| #setup_request_data | 0.273 ms | 5.881 ms | 0.355 ms     | 35.542 ms  | 100         |
| #setup              | 0.089 ms | 0.134 ms | 0.102 ms     | 10.242 ms  | 100         |
| #scenario           | 0.003 ms | 0.036 ms | 0.004 ms     | 1.685 ms   | 400         |
| #initialize         | 0.003 ms | 0.014 ms | 0.004 ms     | 0.418 ms   | 100         |
+---------------------+----------+----------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Scenario
+------------------+-----------+------------+--------------+-------------+-------------+
| Method           | Min Time  | Max Time   | Average Time | Total Time  | Total Calls |
+------------------+-----------+------------+--------------+-------------+-------------+
| #run             | 35.326 ms | 451.642 ms | 45.041 ms    | 4504.068 ms | 100         |
| #perform_setup   | 26.434 ms | 389.205 ms | 35.044 ms    | 3504.389 ms | 100         |
| #perform_request | 4.517 ms  | 19.987 ms  | 5.925 ms     | 592.473 ms  | 100         |
| #setup_request   | 0.559 ms  | 39.922 ms  | 1.075 ms     | 107.483 ms  | 100         |
| #file            | 0.004 ms  | 0.591 ms   | 0.176 ms     | 35.136 ms   | 200         |
| #controller_name | 0.078 ms  | 0.204 ms   | 0.101 ms     | 20.296 ms   | 200         |
| #initialize      | 0.012 ms  | 0.051 ms   | 0.017 ms     | 1.651 ms    | 100         |
| #method          | 0.004 ms  | 0.079 ms   | 0.007 ms     | 0.674 ms    | 100         |
| #setups          | 0.003 ms  | 0.030 ms   | 0.005 ms     | 1.056 ms    | 200         |
| #action          | 0.004 ms  | 0.024 ms   | 0.005 ms     | 1.011 ms    | 200         |
| #params          | 0.004 ms  | 0.025 ms   | 0.005 ms     | 0.488 ms    | 100         |
| #name            | 0.004 ms  | 0.045 ms   | 0.005 ms     | 0.954 ms    | 200         |
| #controller      | 0.003 ms  | 0.053 ms   | 0.004 ms     | 1.741 ms    | 400         |
| #params=         | 0.003 ms  | 0.015 ms   | 0.004 ms     | 0.422 ms    | 100         |
| #controller=     | 0.003 ms  | 0.015 ms   | 0.004 ms     | 0.410 ms    | 100         |
| #action=         | 0.003 ms  | 0.014 ms   | 0.004 ms     | 0.407 ms    | 100         |
| #method=         | 0.003 ms  | 0.013 ms   | 0.004 ms     | 0.406 ms    | 100         |
+------------------+-----------+------------+--------------+-------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::FixtureFile
+------------------+----------+-----------+--------------+------------+-------------+
| Method           | Min Time | Max Time  | Average Time | Total Time | Total Calls |
+------------------+----------+-----------+--------------+------------+-------------+
| #save            | 1.656 ms | 36.758 ms | 2.358 ms     | 235.835 ms | 100         |
| #to_js           | 0.610 ms | 1.478 ms  | 0.756 ms     | 75.631 ms  | 100         |
| #filename        | 0.410 ms | 1.346 ms  | 0.512 ms     | 102.453 ms | 200         |
| #content         | 0.415 ms | 1.148 ms  | 0.512 ms     | 51.176 ms  | 100         |
| #path            | 0.272 ms | 0.986 ms  | 0.343 ms     | 102.900 ms | 300         |
| #meta            | 0.181 ms | 0.737 ms  | 0.227 ms     | 22.672 ms  | 100         |
| #initialize      | 0.005 ms | 0.012 ms  | 0.007 ms     | 0.654 ms   | 100         |
| #controller_name | 0.003 ms | 0.068 ms  | 0.005 ms     | 1.988 ms   | 400         |
| #action          | 0.003 ms | 0.171 ms  | 0.005 ms     | 1.974 ms   | 400         |
| #name            | 0.003 ms | 0.055 ms  | 0.004 ms     | 1.290 ms   | 300         |
| #response        | 0.003 ms | 0.052 ms  | 0.004 ms     | 2.140 ms   | 500         |
+------------------+----------+-----------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Registry
+-------------+----------+----------+--------------+------------+-------------+
| Method      | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-------------+----------+----------+--------------+------------+-------------+
| #all        | 0.028 ms | 0.028 ms | 0.028 ms     | 0.028 ms   | 1           |
| #initialize | 0.006 ms | 0.006 ms | 0.006 ms     | 0.006 ms   | 1           |
| #register   | 0.004 ms | 0.009 ms | 0.004 ms     | 0.443 ms   | 100         |
+-------------+----------+----------+--------------+------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Request
+-----------------+----------+------------+--------------+-------------+-------------+
| Method          | Min Time | Max Time   | Average Time | Total Time  | Total Calls |
+-----------------+----------+------------+--------------+-------------+-------------+
| #_setup         | 4.574 ms | 366.303 ms | 17.354 ms    | 3470.862 ms | 200         |
| #set_controller | 0.020 ms | 0.069 ms   | 0.029 ms     | 2.886 ms    | 100         |
+-----------------+----------+------------+--------------+-------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::Runner
+----------------------------+-------------+-------------+--------------+-------------+-------------+
| Method                     | Min Time    | Max Time    | Average Time | Total Time  | Total Calls |
+----------------------------+-------------+-------------+--------------+-------------+-------------+
| #initialize                | 4596.489 ms | 4596.489 ms | 4596.489 ms  | 4596.489 ms | 1           |
| #run                       | 4596.127 ms | 4596.127 ms | 4596.127 ms  | 4596.127 ms | 1           |
| #start_message             | 0.344 ms    | 0.344 ms    | 0.344 ms     | 0.344 ms    | 1           |
| #scenarios_for_controllers | 0.120 ms    | 0.120 ms    | 0.120 ms     | 0.120 ms    | 1           |
| #controllers_for_files     | 0.007 ms    | 0.007 ms    | 0.007 ms     | 0.007 ms    | 1           |
| #matches_for_controllers   | 0.005 ms    | 0.005 ms    | 0.005 ms     | 0.005 ms    | 1           |
+----------------------------+-------------+-------------+--------------+-------------+-------------+

18:06:03 - INFO - MethodProfiler results for: Alfred::UI
+-------------+----------+----------+--------------+------------+-------------+
| Method      | Min Time | Max Time | Average Time | Total Time | Total Calls |
+-------------+----------+----------+--------------+------------+-------------+
| .info       | 0.221 ms | 0.371 ms | 0.301 ms     | 3.008 ms   | 10          |
| #display    | 0.015 ms | 0.196 ms | 0.053 ms     | 0.588 ms   | 11          |
| #queue      | 0.007 ms | 0.132 ms | 0.016 ms     | 1.759 ms   | 111         |
| #timestamp  | 0.011 ms | 0.029 ms | 0.015 ms     | 0.170 ms   | 11          |
| #initialize | 0.004 ms | 0.007 ms | 0.005 ms     | 0.051 ms   | 11          |
+-------------+----------+----------+--------------+------------+-------------+
```
