class DistrictsController < ApplicationController
  def index
    @districts = District.includes(:counties, :sub_counties)
  end

  def show
    @district = District.includes(counties: :sub_counties).find(params[:id])
  end

  def new
    @district = District.new
    3.times do
      county = @district.counties.build
      2.times { county.sub_counties.build }
    end
  end

  def create
    @district = District.new(district_params)
    if @district.save
      redirect_to @district, notice: "District was successfully created."
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
