class FilterService
  include BeneficiaryFilterMethods
  include GeneralFilterMethods

  def initialize(model, params)
    @model = model
    @params = sanitize_params(params.to_h.symbolize_keys)

    @complex_filters = {
      member_count: ->(rel, p) { filter_by_member_count(rel, p[:min_member], p[:max_member]) },
      date_range: ->(rel, p) { filter_by_date_range(rel, p[:start_date], p[:end_date]) },
      location: ->(rel, p) { filter_by_location(rel, p[:district_id], p[:county_id], p[:sub_county_id]) }
    }
  end

  def apply
    base = @complex_filters.reduce(@model) do |rel, (_key, func)|
      func.call(rel, @params)
    end

    @params.reduce(base) do |rel, (key, value)|
      next rel if @complex_filters.key?(key) || !respond_to?("filter_by_#{key}", true)

      send("filter_by_#{key}", rel, value)
    end
  rescue StandardError => e
    Rails.logger.error("FilterService error: #{e.message}")
    @model
  end

  private

  def sanitize_params(params)
    params.each do |key, value|
      params[key] = sanitize_value(key, value)
    end

    params.reject { |_, v| v.nil? || (v.is_a?(String) && v.empty?) }
  end

  def sanitize_value(key, value)
    if uuid_key?(key)
      valid_uuid?(value) ? value : nil
    elsif integer_range_key?(key)
      valid_integer_string?(value) ? value.to_i : nil
    else
      value
    end
  end

  def uuid_key?(key)
    %i[district_id county_id sub_county_id branch_id request_id event_id].include?(key)
  end

  def integer_range_key?(key)
    %i[min_age max_age min_member max_member].include?(key)
  end

  def valid_uuid?(value)
    value.to_s.match?(/\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/i)
  end

  def valid_integer_string?(value)
    value.present? && value.to_s.match?(/\A\d+\z/)
  end
end
