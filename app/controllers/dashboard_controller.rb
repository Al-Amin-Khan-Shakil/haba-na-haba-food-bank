class DashboardController < ApplicationController
  def index
    time_range = params[:time_range]&.to_sym || :last_7_days

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
      start_date = Date.new(end_date.year, 1, 1)
    else
      start_date = 7.days.ago.to_date
    end

    group_clause = time_range == :current_year ? "DATE_TRUNC('month', created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')" : "DATE(created_at AT TIME ZONE 'UTC' AT TIME ZONE '+06:00')"

    @food_requests = Request.food_request
                            .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                            .group(group_clause)
                            .count
    @donation_requests = Request.donation_request
                                .where(created_at: start_date.beginning_of_day..end_date.end_of_day)
                                .group(group_clause)
                                .count

    @dates = if time_range == :current_year
               (1..12).map { |month| Date.new(end_date.year, month, 1).strftime("%b") }
             else
               (start_date..end_date).map { |date| date.strftime("%d %b") }
             end

    @food_data = Array.new(@dates.length, 0)
    @donation_data = Array.new(@dates.length, 0)

    if time_range == :current_year
      @food_requests.each do |date, count|
        month_index = date.month - 1
        @food_data[month_index] = count if month_index >= 0 && month_index < @dates.length
      end
      @donation_requests.each do |date, count|
        month_index = date.month - 1
        @donation_data[month_index] = count if month_index >= 0 && month_index < @dates.length
      end
    else
      @food_requests.each do |date, count|
        index = (date.to_date - start_date).to_i
        @food_data[index] = count if index >= 0 && index < @dates.length
      end
      @donation_requests.each do |date, count|
        index = (date.to_date - start_date).to_i
        @donation_data[index] = count if index >= 0 && index < @dates.length
      end
    end

    @current_time_range = time_range
    @start_date = start_date
    @end_date = end_date
  end
end