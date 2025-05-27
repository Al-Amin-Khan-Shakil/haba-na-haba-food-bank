class DashboardController < ApplicationController
  def index
    # Default to last 7 days if no time_range is provided
    time_range = params[:time_range]&.to_sym || :last_7_days

    # Set date range based on time_range
    end_date = Date.today
    case time_range
    when :today
      start_date = end_date
    when :yesterday
      start_date = 1.day.ago.to_date
      end_date = start_date
    when :last_7_days
      start_date = 7.days.ago.to_date
    when :last_30_days
      start_date = 30.days.ago.to_date
    when :last_90_days
      start_date = 90.days.ago.to_date
    when :current_year
      start_date = Date.new(end_date.year, 1, 1) # Start of the current year (Jan 1, 2025)
    else
      start_date = 7.days.ago.to_date # Fallback to last 7 days
    end

    # Determine grouping based on time range
    group_clause = time_range == :current_year ? "DATE_TRUNC('month', created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')" : "DATE(created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')"

    # Fetch counts with timezone adjustment for PostgreSQL (convert UTC to +06:00)
    @food_requests = Request.food_request
                            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                            .group(group_clause)
                            .count
    @donation_requests = Request.donation_request
                                .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                                .group(group_clause)
                                .count

    # Generate date range for display
    @dates = if time_range == :current_year
               # Monthly labels for the current year
               (1..12).map { |month| Date.new(end_date.year, month, 1).strftime("%b") }
             else
               # Daily dates for other ranges
               (start_date..end_date).map { |date| date.strftime("%d %b") }
             end

    # Initialize and populate data arrays
    @food_data = Array.new(@dates.length, 0)
    @donation_data = Array.new(@dates.length, 0)

    if time_range == :current_year
      # Aggregate monthly totals
      @food_requests.each do |date, count|
        month_index = date.month - 1 # 0-based index (Jan = 0, Dec = 11)
        @food_data[month_index] = count if month_index >= 0 && month_index < @dates.length
      end
      @donation_requests.each do |date, count|
        month_index = date.month - 1
        @donation_data[month_index] = count if month_index >= 0 && month_index < @dates.length
      end
    else
      # Daily data for other ranges
      @food_requests.each do |date, count|
        index = (date.to_date - start_date).to_i
        @food_data[index] = count if index >= 0 && index < @dates.length
      end
      @donation_requests.each do |date, count|
        index = (date.to_date - start_date).to_i
        @donation_data[index] = count if index >= 0 && index < @dates.length
      end
    end

    # Store the current time range for the view
    @current_time_range = time_range
  end
end