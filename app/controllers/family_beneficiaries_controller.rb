class FamilyBeneficiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[new create]
  before_action :set_family_beneficiary, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new create edit update]

  def index
    @family_beneficiaries = FamilyBeneficiary.all
  end

  def show
    @family_beneficiary = FamilyBeneficiary.find(params[:id])
    @request = @family_beneficiary.request
  end

  def new
    if @request.family_beneficiary.present?
      redirect_to family_beneficiary_path(@request.family_beneficiary),
                  notice: 'Family Beneficiary already exists for this request.'
    else
      @family_beneficiary = @request.build_family_beneficiary
    end
  end

  def create
    if @request.family_beneficiary.present?
      redirect_to family_beneficiary_path(@request.family_beneficiary),
                  notice: 'Family Beneficiary already exists for this request.'
    else
      @family_beneficiary = @request.build_family_beneficiary(family_beneficiary_params)
      if @family_beneficiary.save
        redirect_to family_beneficiary_path(@family_beneficiary), notice: 'Family Beneficiary was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update
    if @family_beneficiary.update(family_beneficiary_params)
      redirect_to family_beneficiary_path(@family_beneficiary), notice: 'Family Beneficiary was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @family_beneficiary.destroy
    redirect_to family_beneficiaries_url, notice: 'Family Beneficiary was successfully destroyed.'
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

  def set_family_beneficiary
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @family_beneficiary = @request.family_beneficiary
    else
      @family_beneficiary = FamilyBeneficiary.find(params[:id])
    end
  end

  def set_form_dependencies
    @users = User.all
    @districts = District.all
    @counties = @request&.district&.counties || []
    @sub_counties = @request&.county&.sub_counties || []
    @branches = Branch.all
    @events = Event.all
  end

  def family_beneficiary_params
    params.require(:family_beneficiary).permit(
      basic_info_params,
      location_params,
      parental_details_params,
      meals_info_params,
      case_info_params
    )
  end

  def basic_info_params
    %i[
      family_members
      male
      female
      children
      adult_age_range
      children_age_range
    ]
  end

  def location_params
    %i[
      district_id
      county_id
      sub_county_id
      residence_address
      village
      parish
    ]
  end

  def parental_details_params
    %i[
      fathers_name
      mothers_name
      fathers_occupation
      mothers_occupation
    ]
  end

  def meals_info_params
    %i[
      number_of_meals_home
      number_of_meals_school
      basic_FEH
      basic_FES
    ]
  end

  def case_info_params
    %i[case_name case_description phone_number request_id]
  end
end
