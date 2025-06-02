class IndividualBeneficiariesController < ApplicationController
  include BeneficiaryGuard

  before_action :authenticate_user!
  before_action :set_parent_resource, only: %i[new create]
  before_action :set_individual_beneficiary, only: %i[show edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]
  before_action :redirect_if_beneficiary_exists, only: %i[new create]

  def index
    filter_applied = filter_params.except(:commit).reject { |_, v| v.blank? }.present?

    if filter_applied
      @individual_beneficiaries = FilterService.new(IndividualBeneficiary.all,
                                                    filter_params).apply.order(created_at: :desc)
    else
      default_params = filter_params.merge(start_date: 7.days.ago.to_date.to_s, end_date: Date.current.to_s)
      @individual_beneficiaries = FilterService.new(IndividualBeneficiary.all,
                                                    default_params).apply.order(created_at: :desc)
    end

    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @branches = Branch.all
    @events = Event.all
  end

  def show; end

  def new
    @individual_beneficiary = if @event
                                @event.individual_beneficiaries.build
                              else
                                @request.individual_beneficiary || @request.build_individual_beneficiary
                              end
  end

  def create
    @individual_beneficiary = if @event
                                @event.individual_beneficiaries.build(individual_beneficiary_params)
                              else
                                @request.build_individual_beneficiary(individual_beneficiary_params)
                              end

    if @individual_beneficiary.save
      redirect_to @individual_beneficiary, notice: 'Individual Beneficiary was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @individual_beneficiary.update(individual_beneficiary_params)
      redirect_to @individual_beneficiary, notice: 'Individual Beneficiary was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @individual_beneficiary.destroy
    redirect_to individual_beneficiaries_url, notice: 'Individual Beneficiary was successfully destroyed.'
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

  def set_individual_beneficiary
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @individual_beneficiary = IndividualBeneficiary.find(params[:id])
    elsif params[:request_id]
      @request = Request.find(params[:request_id])
      @individual_beneficiary = @request.individual_beneficiary
    else
      @individual_beneficiary = IndividualBeneficiary.find(params[:id])
      @request = @individual_beneficiary&.request
      @event = @individual_beneficiary&.event
    end
  end

  def effective_district
    @individual_beneficiary&.district || @request&.district
  end

  def effective_county
    @individual_beneficiary&.county || @request&.county
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
    params.permit(:name, :gender, :min_age, :max_age, :fathers_name, :mothers_name, :case_name, :phone_number,
                  :district_id, :county_id, :sub_county_id, :age,
                  :branch_id, :event_id, :start_date, :end_date, :provided_food, :action, :commit)
  end

  def individual_beneficiary_params
    params.require(:individual_beneficiary).permit(:name, :age, :gender, :case_name, :case_description, :phone_number,
                                                   :father_name, :mother_name, :sur_name, :provided_food,
                                                   :village, :parish, :address_note, :district_id, :county_id,
                                                   :sub_county_id, :request_id, :branch_id, :event_id)
  end
end
