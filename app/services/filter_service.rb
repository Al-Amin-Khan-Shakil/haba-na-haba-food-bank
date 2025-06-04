class FilterService
  include BeneficiaryFilterMethods
  include GeneralFilterMethods
  include EventFilterMethods

  def initialize(model, params)
    @model = model
    @params = params.to_h.symbolize_keys

    @complex_filters = {
      member_count: ->(rel, p) { filter_by_member_count(rel, p[:min_member], p[:max_member]) },
      age: ->(rel, p) { filter_by_age(rel, p[:min_age], p[:max_age]) },
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
end
