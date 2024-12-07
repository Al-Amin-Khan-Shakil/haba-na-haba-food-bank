class DistrictsController < ApplicationController
  def index
    @districts = District.includes(:counties, :sub_counties)
  end

  def new
    @district = District.new
    @district.counties.build.sub_counties.build
  end

  def create
    @district = District.new(district_params)
    if @district.save
      redirect_to districts_path, notice: "District was successfully created."
    else
      render :new
    end
  end

  private

  def district_params
    params.require(:district).permit(
      :name,
      counties_attributes: [
        :id, :name, :_destroy,
        sub_counties_attributes: [:id, :name, :_destroy]
      ]
    )
  end
end
