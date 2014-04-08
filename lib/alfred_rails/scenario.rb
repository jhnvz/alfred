module Alfred
  class Scenario

    ## Attributes

    attr_accessor :name, :setups, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Alfred scenario.
    #
    # === Params
    #
    # [name (String)] name of the scenario
    #
    # === Example
    #
    #   Scenario.new('admin permissions')
    #
    def initialize(name)
      @name   = name.downcase.gsub(' ', '_')
      @setups = []
    end

    ##
    # Returns the controller name based on controller.
    #
    # === Examples
    #
    #   scenario = Scenario.new('test')
    #   scenario.controller = Api::V1::UserController
    #
    #   scenario.controller_name #=> 'api/v1/users_controller'
    #
    def controller_name
      controller.name.underscore
    end

    ##
    # Runs the scenario.
    #
    def run
      controller.send(:include, ::Rails.application.routes.url_helpers)

      ## Initialize mocking framework
      Alfred::Mock.new

      ## Include modules from configuration
      Alfred.configuration.includes.each do |mod|
        Request.send(:include, mod)
      end

      ## Setup request
      request = Request.new(name)
      request.set_controller(controller)
      request.setup_controller_request_and_response

      ## Run global setup before example
      Alfred.configuration.setup.each do |setup|
        request._setup(&setup)
      end

      ## Run setup blocks for scenario
      setups.each { |setup| request._setup(&setup) }

      ## Perform request
      request.send(method, action, params)

      ## Set response
      @response = request.response

      ## Persist response to disk
      save!
    end

    class FixtureFile

      attr_reader :response, :controller_name, :action, :name

      def initialize(response, controller_name, action, name)
        @response = response
        @controller_name = controller_name
        @action = action
        @name = name
      end

      ##
      # Returns the path name to save the fixture.
      #
      def path
        "#{Alfred.fixture_path}/#{controller_name}/#{action}"
      end

      ##
      # Returns the folder name to save the fixture.
      #
      def filename
        "#{path}/#{name.underscore}.js"
      end

      ##
      # Saves the fixture.
      #
      def save
        FileUtils.mkdir_p(path)

        File.open(filename, 'w') do |fixture|
          fixture.write(content.to_js)
        end
      end

      ##
      # Outputs the content to a JavaScript format wrapped around Alfred.register JavaScript method
      #
      def to_js
        "Alfred.register(#{content.to_json})"
      end

      ##
      # Scenario content with meta data outputted as a hash.
      #
      def content
        {
          :name     => name,
          :action   => "#{controller_name}/#{action}",
          :meta     => meta,
          :response => response.body
        }
      end

      ##
      # Scenario meta data, such as path, method, status and content type
      #
      def meta
        {
          :path   => response.request.fullpath,
          :method => response.request.method,
          :status => response.status,
          :type   => response.content_type,
        }
      end

    end

    ##
    # Persist the response on disk.
    #
    def save
      file = FixtureFile.new(@response, controller_name, action, name)
      file.save
    end
    alias :save! :save

  end # Scenario
end # Alfred
