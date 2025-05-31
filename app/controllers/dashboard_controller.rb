class DashboardController < ApplicationController
  def index
    fetch_line_chart_data
    fetch_pie_chart_data
    fetch_additional_metrics
  end

  def pie_chart
    service = PieChartService.new(params[:time_range])
    @percentages = service.percentages
    @current_time_range = service.time_range
    @start_date = service.start_date
    @end_date = service.end_date
  end

  private

  def fetch_line_chart_data
    line_chart_service = DashboardDataService.new(params[:time_range])
    @food_requests = line_chart_service.food_requests
    @donation_requests = line_chart_service.donation_requests
    @dates = line_chart_service.dates
    @food_data = line_chart_service.food_data
    @donation_data = line_chart_service.donation_data
    @current_time_range = line_chart_service.time_range
    @start_date = line_chart_service.start_date
    @end_date = line_chart_service.end_date
  end

  def fetch_pie_chart_data
    pie_chart_service = PieChartService.new(params[:time_range])
    @percentages = pie_chart_service.percentages
  end

  def fetch_additional_metrics
    @branch_count = Branch.count
    @user_count = User.count
    @branch_manager_percentage = calculate_percentage(User.where(role: 'branch_manager').count, @user_count)
    @volunteer_percentage = calculate_percentage(User.where(role: 'volunteer').count, @user_count)
  end

  def calculate_percentage(part, total)
    return 0.0 if total.zero?

    ((part.to_f / total) * 100).round(0)
  end
end
