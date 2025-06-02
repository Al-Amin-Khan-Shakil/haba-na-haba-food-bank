module ApplicationHelper
  def first_model_with_errors
  instance_variables.each do |var|
    value = instance_variable_get(var)

    next unless value.respond_to?(:errors)

    # Skip uninitialized or blank models
    next if value.errors.nil?
    next unless value.errors.respond_to?(:any?) && value.errors.any?

    return value
  end

  nil
  end

end
