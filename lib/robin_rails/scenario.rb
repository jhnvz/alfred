module Robin
  class Scenario

    ## Attributes

    attr_accessor :name, :setup, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Robin.
    #
    # === Params
    #
    # [name (String)] name of the scenario
    # [options (Hash)] optional options
    #
    # === Example
    #
    #   Scenario.new('admin permissions')
    #
    def initialize(name, options={})
      @name = name.downcase.gsub(' ', '_')
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
    # Runs the example.
    #
    def run
      controller.send(:include, ::Rails.application.routes.url_helpers)

      RSpec::Mocks::setup(Object.new)

      # Include modules from configuration
      Robin.configuration.includes_for(:controller).each do |mod|
        Request.send(:include, mod)
      end

      ## Setup request
      request = Request.new(name)

      ## Run global setup before example
      Robin.configuration.config[:before].each do |before|
        request._setup(&before)
      end

      request.set_controller(controller.new)
      request.setup_controller_request_and_response

      request._setup(&setup)

      ## Perform request
      request.send(method, action, params)

      ## Set response
      @response = request.response

      ## Persist response to disk
      save!
    end

    ##
    # Returns the path name to save the fixture.
    #
    def path
      "#{::Rails.root}/spec/fixtures/#{controller_name}/#{action}"
    end

    ##
    # Returns the folder name to save the fixture.
    #
    def filename
      "#{path}/#{name}.#{format}"
    end

    ##
    # Returns the file format for response content type.
    #
    def format
      case @response.content_type
      when 'application/json' then 'json'
      when 'application/html' then 'html'
      when 'application/xml'  then 'xml'
      end
    end

    ##
    # Persist the response on disk.
    #
    def save
      FileUtils.mkdir_p(path)

      File.open(filename, 'w') do |fixture|
        fixture.write(@response.body)
      end

      STDOUT.print("Robin: Created fixture at: #{filename}\n")
    end
    alias :save! :save

  end # Scenario
end # Robin
