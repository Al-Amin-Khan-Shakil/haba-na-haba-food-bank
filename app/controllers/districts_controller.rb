class DistrictsController < ApplicationController
  def index
    @districts = District.all
  end

  def show
    @district = District.includes(counties: :sub_counties).find(params[:id])
  end

  def new
    @district = District.new
    @district.counties.build.sub_counties.build # Initialize nested counties and sub-counties
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

  # def district_params
  #   params.require(:district).permit(
  #     :name,
  #     counties_attributes: [
  #       :id, :name, :_destroy,
  #       sub_counties_attributes: [:id, :name, :_destroy]
  #     ]
  #   )
  # end

  def district_params
    params.require(:district).permit(
      :name,
      counties_attributes: [:id, :name, :district_id, :_destroy, sub_counties_attributes: [:id, :name, :county_id, :_destroy]]
    )
  end
end
