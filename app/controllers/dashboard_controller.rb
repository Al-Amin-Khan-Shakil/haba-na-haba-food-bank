class DashboardController < ApplicationController
  def index
    service = DashboardDataService.new(params[:time_range])
    @food_requests = service.food_requests
    @donation_requests = service.donation_requests
    @dates = service.dates
    @food_data = service.food_data
    @donation_data = service.donation_data
    @current_time_range = service.time_range
    @start_date = service.start_date
    @end_date = service.end_date
  end
end