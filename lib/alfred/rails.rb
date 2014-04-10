module Alfred
  module Rails
    class Engine < ::Rails::Engine; end

    # :nocov:
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load "tasks/alfred.rake"
      end
    end # Railtie
    # :nocov:

  end # Rails
end # Alfred
