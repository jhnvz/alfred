ENV["RAILS_ENV"] ||= 'test'

require 'guard'
require 'guard/plugin'

module Guard
  class Robin < Plugin
    require 'guard/robin/runner'

    attr_accessor :options, :runner

    def initialize(options = {})
      super

      @options = {
        :all_on_start         => true,
        :run_all              => {},
        :run_on_modifications => {}
      }.merge(options)

      @runner = Runner.new(@options)
    end

    def start
      ::Guard::UI.info 'Guard::Robin is running'
      run_all if @options[:all_on_start]
    end

    def run_all
      runner.run_all
    end

    def reload
      runner.reload
    end

    def run_on_modifications(paths)
      return false if paths.empty?
      runner.run(paths)
    end

  end # Robin
end # Guard