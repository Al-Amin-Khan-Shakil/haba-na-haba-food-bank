class FamilyBeneficiariesController < ApplicationController
  include BeneficiaryGuard

  before_action :authenticate_user!
  before_action :set_parent_resource, only: %i[new create]
  before_action :set_family_beneficiary, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new create edit update]
  before_action :redirect_if_beneficiary_exists, only: %i[new create]

  def index
    @family_beneficiaries = FilterService.new(FamilyBeneficiary.all, filter_params).apply
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @branches = Branch.all
  end

  def show; end

  def new
    @family_beneficiary = if @event
                            @event.family_beneficiaries.build
                          else
                            @request.family_beneficiary || @request.build_family_beneficiary
                          end
  end

  def create
    @family_beneficiary = if @event
                            @event.family_beneficiaries.build(family_beneficiary_params)
                          else
                            @request.build_family_beneficiary(family_beneficiary_params)
                          end

    if @family_beneficiary.save
      redirect_to @family_beneficiary, notice: 'Family Beneficiary was successfully created.'
    else
      render :new, status: :unprocessable_entity
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

  def set_parent_resource
    if params[:event_id]
      @event = Event.find(params[:event_id])
    elsif params[:request_id]
      @request = Request.find(params[:request_id])
    end
  end

  def set_family_beneficiary
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @family_beneficiary = FamilyBeneficiary.find(params[:id])
    elsif params[:request_id]
      @request = Request.find(params[:request_id])
      @family_beneficiary = @request.family_beneficiary
    else
      @family_beneficiary = FamilyBeneficiary.find(params[:id])
      @request = @family_beneficiary&.request
      @event = @family_beneficiary&.event
    end
  end

  def effective_district
    @family_beneficiary&.district || @request&.district
  end

  def effective_county
    @family_beneficiary&.county || @request&.county
  end

  def set_form_dependencies
    @users = User.all
    @districts = District.all
    @counties = effective_district&.counties || []
    @sub_counties = effective_county&.sub_counties || []
    @branches = Branch.all
    @events = Event.all
  end

  def filter_params
    params.permit(:fathers_name, :mothers_name, :case_name, :phone_number,
                  :min_member, :max_member, :district_id, :county_id, :sub_county_id,
                  :branch_id, :start_date, :end_date, :provided_food, :commit)
  end

  def family_beneficiary_params
    params.require(:family_beneficiary).permit(:family_members, :male, :female, :children, :adult_age_range,
                                               :children_age_range, :district_id, :county_id, :sub_county_id,
                                               :address_note, :village, :parish, :fathers_name, :mothers_name,
                                               :fathers_occupation, :mothers_occupation, :number_of_meals_home,
                                               :number_of_meals_school, :provided_food, :basic_FEH, :basic_FES,
                                               :case_name, :case_description, :phone_number, :request_id)
  end
end
