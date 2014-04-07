class ResponseProxy

  attr_accessor :content_type

  def initialize(attributes={})
    attributes.keys.each do |key|
      instance_variable_set("@#{key}".to_sym, attributes[key])
    end
  end

end
