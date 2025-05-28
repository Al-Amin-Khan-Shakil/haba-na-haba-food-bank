class DashboardController < ApplicationController
  def index
    # Fetch data for the line chart
    line_chart_service = DashboardDataService.new(params[:time_range])
    @food_requests = line_chart_service.food_requests
    @donation_requests = line_chart_service.donation_requests
    @dates = line_chart_service.dates
    @food_data = line_chart_service.food_data
    @donation_data = line_chart_service.donation_data
    @current_time_range = line_chart_service.time_range
    @start_date = line_chart_service.start_date
    @end_date = line_chart_service.end_date

    # Fetch data for the pie chart
    pie_chart_service = PieChartService.new(params[:time_range])
    @percentages = pie_chart_service.percentages
  end
end
