module Initializer
  def set_instance_variables(defaults, inputs, options={})
    data = defaults.merge(inputs)
    defaults.keys.each do |varname|
      instance_variable_set("@#{varname}", data[varname])
    end
    if options[:required]
      options[:required].each do |key|
        raise "@#{key} can't be nil" unless instance_variable_get("@#{key}")
      end
    end
  end
end
