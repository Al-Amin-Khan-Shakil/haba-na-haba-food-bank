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

  UUID_KEYS = %i[district_id county_id sub_county_id branch_id request_id event_id].freeze
  INTEGER_KEYS = %i[min_age max_age min_member max_member].freeze

  def sanitize_params(params)
    params.to_h.symbolize_keys.each_with_object({}) do |(key, value), acc|
      sanitized_value = sanitize_single_param(key, value)
      unless sanitized_value.nil? || (sanitized_value.is_a?(String) && sanitized_value.empty?)
        acc[key] =
          sanitized_value
      end
    end
  end

  def sanitize_single_param(key, value)
    if UUID_KEYS.include?(key)
      value.to_s.match?(/\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/i) ? value : nil
    elsif INTEGER_KEYS.include?(key)
      value.to_i if value.present? && value.to_s.match?(/\A\d+\z/)
    else
      value
    end
  end
end
