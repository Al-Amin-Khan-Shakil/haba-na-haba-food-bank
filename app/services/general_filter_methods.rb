module GeneralFilterMethods
  private

  def filter_by_date_range(model, start_date, end_date)
    parsed_start = parse_date(start_date)
    parsed_end = parse_date(end_date)

    parsed_end = fix_end_date_if_before_start(parsed_start, parsed_end)

    date_column = model_class_column(model)

    return filter_with_both_dates(model, parsed_start, parsed_end, date_column) if parsed_start && parsed_end
    return filter_with_start_date(model, parsed_start, date_column) if parsed_start
    return filter_with_end_date(model, parsed_end, date_column) if parsed_end

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

  def model_class_column(model)
    model.klass.name == 'Event' ? :start_date : :created_at
  end

  def filter_with_both_dates(model, start_date, end_date, column)
    model.where(column => start_date.beginning_of_day..end_date.end_of_day)
  end

  def filter_with_start_date(model, start_date, column)
    model.where("#{column} >= ?", start_date.beginning_of_day)
  end

  def filter_with_end_date(model, end_date, column)
    model.where(column => Date.current.beginning_of_year..end_date.end_of_day)
  end
end
