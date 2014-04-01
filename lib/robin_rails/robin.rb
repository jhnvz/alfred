module RobinRails
  class Robin

    ## Attributes

    attr_accessor :name, :setup, :method, :controller, :action, :params, :identifier

    ##
    # Initialize a new Robin.
    #
    # === Params
    #
    # [name (String)] name of the definition
    # [options (Hash)] optional options
    #
    # === Example
    #
    # Robin.new('admin permissions')
    #
    def initialize(name, options={})
      @name = name.downcase.gsub(' ', '_')
    end

    ##
    # Set the identifier so we can lookup robins.
    #
    def set_identifier
      self.identifier = "#{name}/#{method}/#{controller_name}/#{action}"
    end

    ##
    # Returns the controller name based on controller.
    #
    # === Examples
    #
    # robin = Robin.new('test')
    # robin.controller = Api::V1::UserController
    #
    # robin.controller_name #=> 'api/v1/users_controller'
    #
    def controller_name
      controller.name.underscore
    end

    ##
    # Runs the example.
    #
    def run
      controller.send(:include, Rails.application.routes.url_helpers)

      ## Setup request
      request = Request.new(name)
      request.setup(&setup)
      request.set_controller(controller.new)
      request.setup_controller_request_and_response

      ## Perform request
      request.send(method, action, params)

      ## Set response
      @response = request.response

      ## Persist response to disk
      save!

      ## Clean up the database
      DatabaseCleaner.clean
    end

    ##
    # Returns the path name to save the fixture.
    #
    def path
      "#{Rails.root}/spec/fixtures/#{controller_name}/#{action}"
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
    end
    alias :save! :save

  end # Robin
end # RobinRails
