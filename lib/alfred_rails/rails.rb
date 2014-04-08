module Alfred
  module Rails
    class Engine < ::Rails::Engine; end

    class Railtie < ::Rails::Railtie
      rake_tasks do
        #:nocov:
        load "tasks/alfred.rake"
        #:nocov:
      end
    end # Railtie

  end # Rails
end # Alfred
