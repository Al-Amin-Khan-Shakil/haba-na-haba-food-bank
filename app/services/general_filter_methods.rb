module GeneralFilterMethods
  private

  def filter_by_date_range(model, start_date, end_date, column = nil)
    # Fallback to :start_date if it exists, else :created_at
    column ||= model.column_names.include?("start_date") ? :start_date : :created_at

    parsed_start = parse_date(start_date)
    parsed_end = parse_date(end_date)

    # Ensure logical date order
    parsed_end = fix_end_date_if_before_start(parsed_start, parsed_end)

    # Filtering logic
    return filter_with_both_exact_dates(model, parsed_start, parsed_end, column) if parsed_start && parsed_end
    return filter_with_exact_start_date(model, parsed_start, column) if parsed_start
    return filter_with_exact_end_date(model, parsed_end, column) if parsed_end

    model
  rescue ArgumentError => e
    Rails.logger.error "Invalid date format: #{e.message}"
    model
  end

  def parse_date(date_string)
    return nil unless date_string.present?
    Date.parse(date_string)
  end

  def fix_end_date_if_before_start(start_date, end_date)
    return end_date unless start_date && end_date && end_date < start_date
    Date.current
  end

  # Match exact start AND end dates
  def filter_with_both_exact_dates(model, start_date, end_date, column)
    model.where("DATE(#{column}) BETWEEN ? AND ?", start_date, end_date)
  end

  # Match exact start date only
  def filter_with_exact_start_date(model, start_date, column)
    model.where("DATE(#{column}) = ?", start_date)
  end

  # Match exact end date only
  def filter_with_exact_end_date(model, end_date, column)
    model.where("DATE(#{column}) = ?", end_date)
  end
end
