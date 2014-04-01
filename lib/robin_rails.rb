require 'robin_rails/version'
require 'robin_rails/configuration'
require 'robin_rails/registry'
require 'robin_rails/definition'
require 'robin_rails/robin'
require 'robin_rails/robin_proxy'
require 'robin_rails/response'
require 'active_support'

module RobinRails
  extend RobinRails::Definition

  def self.registry
    @registry ||= Registry.new
  end
end
