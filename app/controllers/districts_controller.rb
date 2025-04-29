class DistrictsController < ApplicationController
  before_action :authenticate_user!

  def index
    @districts = District.all
  end

  def show
    @district = District.includes(counties: :sub_counties).find(params[:id])
  end

  def new
    @district = District.new
    @district.counties.build.sub_counties.build
  end

  def create
    @district = District.new(district_params)
    if @district.save
      redirect_to @district, notice: 'District was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @district = District.includes(counties: :sub_counties).find(params[:id])
  end

  def update
    @district = District.includes(counties: :sub_counties).find(params[:id])

    if @district.update(district_params)
      redirect_to @district, notice: 'District was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @district = District.find(params[:id])
    @district.destroy
    redirect_to districts_path, notice: 'District was successfully destroyed.'
  end

  private

  def district_params
    params.require(:district).permit(
      :name,
      counties_attributes: [:id, :name, :district_id, :_destroy, {
        sub_counties_attributes: %i[id name county_id _destroy]
      }]
    )
  end
end
