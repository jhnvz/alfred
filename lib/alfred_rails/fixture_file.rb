module Alfred
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
        fixture.write(to_js)
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
      @content ||= {
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
end
