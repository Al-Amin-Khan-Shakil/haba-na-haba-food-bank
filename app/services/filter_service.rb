class FilterService
  include BeneficiaryFilterMethods
  include GeneralFilterMethods

  UUID_KEYS = %i[district_id county_id sub_county_id branch_id request_id event_id].freeze
  INTEGER_KEYS = %i[min_age max_age min_member max_member].freeze
  UUID_REGEX = /\A[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}\z/i.freeze
  INTEGER_REGEX = /\A\d+\z/.freeze

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
    params.each_with_object({}) do |(key, value), clean_params|
      clean_params[key] = sanitize_value(key, value)
    end.compact
  end

  def sanitize_value(key, value)
    if UUID_KEYS.include?(key)
      value.to_s.match?(UUID_REGEX) ? value : nil
    elsif INTEGER_KEYS.include?(key)
      value.present? && value.to_s.match?(INTEGER_REGEX) ? value.to_i : nil
    else
      value.present? ? value : nil
    end
  end
end
