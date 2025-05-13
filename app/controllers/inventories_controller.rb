class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[new create]
  before_action :set_inventory, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]

  def index
    @inventories = Inventory.all
  end

  def show; end

  def new
    if @request.inventory.present?
      redirect_to inventory_path(@request.inventory),
                  notice: 'Inventory already exists for this request.'
    else
      @inventory = @request.build_inventory
    end
  end

  def create
    if @request.inventory.present?
      redirect_to inventory_path(@request.inventory),
                  notice: 'Inventory already exists for this request.'
    else
      @inventory = @request.build_inventory(inventory_params)

      if @inventory.save
        redirect_to @inventory, notice: 'Inventory was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update
    if @inventory.update(inventory_params)
      redirect_to @inventory, notice: 'Inventory was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_url, notice: 'Inventory was successfully destroyed.'
  end

  def load_counties
    @counties = if params[:district_id].present?
                  County.where(district_id: params[:district_id])
                else
                  County.none
                end
    render json: @counties.map { |county| { id: county.id, name: county.name } }
  end

  def load_sub_counties
    @sub_counties = if params[:county_id].present?
                      SubCounty.where(county_id: params[:county_id])
                    else
                      SubCounty.none
                    end
    render json: @sub_counties.map { |sub_county| { id: sub_county.id, name: sub_county.name } }
  end

  private

  def set_request
    @request = Request.find(params[:request_id]) if params[:request_id]
  end

  def set_inventory
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @inventory = @request.inventory
    else
      @inventory = Inventory.find(params[:id])
      @request = @inventory.request
    end
  end

  def effective_district
    @inventory&.district || @request&.district
  end

  def effective_county
    @inventory&.county || @request&.county
  end

  def set_form_dependencies
    @districts = District.all
    @counties = effective_district&.counties || []
    @sub_counties = effective_county&.sub_counties || []
    @branches = Branch.all
    @events = Event.all
  end

  def inventory_params
    params.require(:inventory).permit(:name, :expire_date, :amount, :cost_of_item,
                                      :collection_place, :district_id, :county_id,
                                      :sub_county_id, :donation_id, :request_id, :branch_id, :event_id)
  end
end
