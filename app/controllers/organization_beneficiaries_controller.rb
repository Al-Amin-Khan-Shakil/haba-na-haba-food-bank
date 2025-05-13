class OrganizationBeneficiariesController < ApplicationController
  include BeneficiaryGuard

  before_action :authenticate_user!
  before_action :set_request, only: %i[new create edit update]
  before_action :set_organization_beneficiary, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]
  before_action :redirect_if_beneficiary_exists, only: %i[new create]

  def index
    @organization_beneficiaries = OrganizationBeneficiary.all
  end

  def show; end

  def new
    @organization_beneficiary = @request.build_organization_beneficiary
  end

  def create
    @organization_beneficiary = @request.build_organization_beneficiary(organization_beneficiary_params)
    if @organization_beneficiary.save
      redirect_to @organization_beneficiary, notice: 'Organization Beneficiary was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @organization_beneficiary.update(organization_beneficiary_params)
      redirect_to @organization_beneficiary, notice: 'Organization Beneficiary was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization_beneficiary.destroy
    redirect_to organization_beneficiaries_url, notice: 'Organization Beneficiary was successfully destroyed.'
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

  def set_organization_beneficiary
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @organization_beneficiary = @request.organization_beneficiary
    else
      @organization_beneficiary = OrganizationBeneficiary.find(params[:id])
      @request = @organization_beneficiary.request
    end
  end

  def effective_district
    @organization_beneficiary&.district || @request&.district
  end

  def effective_county
    @organization_beneficiary&.county || @request&.county
  end

  def set_form_dependencies
    @users = User.all
    @districts = District.all
    @counties = effective_district&.counties || []
    @sub_counties = effective_county&.sub_counties || []
    @branches = Branch.all
    @events = Event.all
  end

  def organization_beneficiary_params
    params.require(:organization_beneficiary).permit(
      :organization_name, :male, :female, :adult_age_range, :children_age_range,
      :address_note, :village, :parish, :phone_number, :case_name, :case_description,
      :registration_no, :organization_no, :directors_name, :head_of_institution,
      :number_of_meals_home, :basic_FEH, :provided_food,
      :district_id, :county_id, :sub_county_id, :branch_id, :request_id, :event_id
    )
  end
end
