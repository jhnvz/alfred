module Robin
  class Runner

    def initialize(paths=[])
      paths = paths.map { |p| p.gsub('.rb', '').gsub('spec/robins/', '') }

      if paths.empty?
        Robin.registry.all.each { |robin| robin.run }
      else
        paths.each do |path|
          Robin.registry[path].each { |robin| robin.run } if Robin.registry[path]
        end
      end
    end

  end # Runner
end # RobinRails
