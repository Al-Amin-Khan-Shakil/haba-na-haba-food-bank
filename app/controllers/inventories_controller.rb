class InventoriesController < ApplicationController
  include BeneficiaryGuard

  before_action :authenticate_user!
  before_action :set_parent_resource, only: %i[new create]
  before_action :set_inventory, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]
  before_action :redirect_if_beneficiary_exists, only: %i[new create]

  def index
    filter_applied = filter_params.except(:commit).reject { |_, v| v.blank? }.present?

    if filter_applied
      @inventories = FilterService.new(Inventory.all, filter_params).apply.order(created_at: :desc)
    else
      default_params = filter_params.merge(start_date: 7.days.ago.to_date.to_s, end_date: Date.current.to_s)
      @inventories = FilterService.new(Inventory.all, default_params).apply.order(created_at: :desc)
    end
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @branches = Branch.all
    @events = Event.all
  end

  def show; end

  def new
    @inventory = if @event
                   @event.inventories.build
                 else
                   @request.inventory || @request.build_inventory
                 end
  end

  def create
    @inventory = if @event
                   @event.inventories.build(inventory_params)
                 else
                   @request.build_inventory(inventory_params)
                 end

    if @inventory.save
      redirect_to @inventory, notice: 'Inventory was successfully created.'
    else
      render :new, status: :unprocessable_entity
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

  def set_parent_resource
    if params[:event_id]
      @event = Event.find(params[:event_id])
    elsif params[:request_id]
      @request = Request.find(params[:request_id])
    end
  end

  def set_inventory
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @inventory = IndividualBeneficiary.find(params[:id])
    elsif params[:request_id]
      @request = Request.find(params[:request_id])
      @inventory = @request.inventory
    else
      @inventory = Inventory.find(params[:id])
      @request = @inventory&.request
      @event = @inventory&.event
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

  def filter_params
    params.permit(:donation_type, :name, :donor_name, :donor_type,
                  :phone_number, :amount, :expire_date, :county_id, :sub_county_id, :created_at,
                  :district_id, :branch_id, :start_date, :end_date, :event_id, :commit)
  end

  def inventory_params
    params.require(:inventory).permit(:name, :expire_date, :amount, :cost_of_item,
                                      :collection_place, :district_id, :county_id,
                                      :sub_county_id, :donation_id, :request_id, :branch_id, :event_id,
                                      :phone_number, :donor_name)
  end
end
