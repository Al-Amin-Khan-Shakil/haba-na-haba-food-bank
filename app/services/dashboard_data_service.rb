class DashboardDataService
  attr_reader :time_range, :start_date, :end_date, :food_requests, :donation_requests,
              :dates, :food_data, :donation_data

  def initialize(time_range_param)
    @time_range = time_range_param&.to_sym || :last_7_days
    calculate_date_range
    fetch_requests
    generate_dates
    initialize_data_arrays
    populate_data_arrays
  end

  private

  def calculate_date_range
    end_date = Date.today
    start_date = case time_range
                 when :today
                   end_date
                 when :yesterday
                   end_date = 1.day.ago.to_date
                   end_date
                 when :last_7_days
                   7.days.ago.to_date
                 when :last_30_days
                   30.days.ago.to_date
                 when :last_90_days
                   90.days.ago.to_date
                 when :current_year
                   Date.new(end_date.year, 1, 1)
                 else
                   Rails.logger.warn "Unrecognized time_range: #{@time_range}, defaulting to last 7 days"
                   7.days.ago.to_date
                 end
    @start_date = start_date
    @end_date = end_date
  end

  def determine_group_clause
    if time_range == :current_year
      "DATE_TRUNC('month', created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')"
    else
      "DATE(created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')"
    end
  end

  def fetch_requests
    group_clause = determine_group_clause
    range = start_date.beginning_of_day..end_date.end_of_day
    @food_requests = Request.food_request.where(created_at: range).group(group_clause).count
    @donation_requests = Request.donation_request.where(created_at: range).group(group_clause).count
  end

  def generate_dates
    @dates = if time_range == :current_year
               (1..12).map { |month| Date.new(end_date.year, month, 1).strftime('%b') }
             else
               (start_date..end_date).map { |date| date.strftime('%d %b') }
             end
  end

  def initialize_data_arrays
    @food_data = Array.new(dates.length, 0)
    @donation_data = Array.new(dates.length, 0)
  end

  def populate_data_arrays
    if time_range == :current_year
      populate_monthly_data
    else
      populate_daily_data
    end
  end

  def populate_monthly_data
    food_requests.each do |date, count|
      month_index = date.month - 1
      food_data[month_index] = count if month_index >= 0 && month_index < dates.length
    end
    donation_requests.each do |date, count|
      month_index = date.month - 1
      donation_data[month_index] = count if month_index >= 0 && month_index < dates.length
    end
  end

  def populate_daily_data
    food_requests.each do |date, count|
      index = (date.to_date - start_date).to_i
      food_data[index] = count if index >= 0 && index < dates.length
    end
    donation_requests.each do |date, count|
      index = (date.to_date - start_date).to_i
      donation_data[index] = count if index >= 0 && index < dates.length
    end
  end
end
