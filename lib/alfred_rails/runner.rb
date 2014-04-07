require 'ruby-progressbar'

module Alfred
  class Runner

    def initialize(paths=[])
      paths = paths.map { |p| p.gsub('.rb', '').gsub('spec/alfreds/', '') }

      if paths.empty?
        scenarios = Alfred.registry.all
      else
        scenarios = []
        paths.each do |path|
          scenarios << Alfred.registry[path]
        end
        scenarios = scenarios.flatten.compact
      end

      if scenarios.any?
        STDOUT.print("\n")

        message  = ["\nAlfred generated the following fixures:\n"]
        progress = ProgressBar.create(
          :starting_at => 0,
          :format      => '%c/%C: |%B| %a',
          :total       => scenarios.size
        )

        scenarios.each do |scenario|
          scenario.run
          progress.increment

          message << "#{scenario.filename}\n"
        end

        message << "\n"
        STDOUT.print(message.join)
      end
    end

  end # Runner
end # Alfred
