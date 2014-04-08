module Alfred
  module Rails
    class Engine < ::Rails::Engine; end

    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/alfred.rake"
      end
    end # Railtie

  end # Rails
end # Alfred
