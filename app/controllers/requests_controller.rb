class RequestsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_request, only: %i[show edit update destroy]

  def index
    filter_applied = filter_params.except(:commit).reject { |_, v| v.blank? }.present?

    if filter_applied
      @requests = FilterService.new(Request.all, filter_params).apply.order(created_at: :desc)
    else
      default_params = filter_params.merge(start_date: 7.days.ago.to_date.to_s, end_date: Date.current.to_s)
      @requests = FilterService.new(Request.all, default_params).apply.order(created_at: :desc)
    end

    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @branches = Branch.all
  end

  def show; end

  def new
    @request = Request.new
    @request.build_donation
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
    @type = params[:type]
  end

  def create
    @request = Request.new(request_params)

    if @request.donation_request?
      @request.donation.donor_name = @request.name
      @request.donation.phone_number = @request.phone_number
    end

    if @request.save
      if current_user
      create_notifications(@request, :created)
      redirect_to @request, notice: 'Request was successfully created.'
      else
        redirect_to authenticated_root_path, notice: 'Request was successfully created.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @request.build_donation if @request.donation_request? && @request.donation.nil?
    @districts = District.all
    @counties = @request.district&.counties || County.none
    @sub_counties = @request.county&.sub_counties || SubCounty.none
  end

  def update
    if @request.update(request_params)
      if @request.donation_request? && @request.donation.present?
        @request.donation.update(
          donor_name: @request.name,
          phone_number: @request.phone_number
        )
      end
      create_notifications(@request, :updated)
      redirect_to @request, notice: 'Request updated successfully'
    else
      @request.build_donation if @request.donation_request? && @request.donation.blank?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    redirect_to requests_path, notice: 'Request was successfully destroyed.'
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
    @request = Request.includes(:donation).find(params[:id])
  end

  def filter_params
    params.permit(:name, :phone_number, :request_type,
                  :district_id, :county_id, :sub_county_id,
                  :is_selected, :branch_id,
                  :start_date, :end_date, :commit)
  end

  def request_params
    params.require(:request).permit(
      :name,
      :phone_number,
      :request_type,
      :branch_id,
      :district_id,
      :county_id,
      :sub_county_id,
      :user_id,
      :is_selected,
      :village,
      :parish,
      :address_note,
      donation_attributes: %i[id donation_type donation_name amount donor_type _destroy]
    )
  end

  def create_notifications(request, action)
    action = action.to_s.downcase

    branch_message = if action == 'updated'
                       "A #{request.request_type.humanize.downcase} has been transferred to your branch."
                     else
                       "A new #{request.request_type.humanize.downcase} has been assigned to your branch."
                     end

    volunteer_message = if action == 'updated'
                          "A #{request.request_type.humanize.downcase} has been transferred to you."
                        else
                          "You have been assigned a new #{request.request_type.humanize.downcase}."
                        end

    User.where(role: 'branch_manager', branch_id: request.branch_id).each do |manager|
      Notification.create(user: manager, notifiable: request, message: branch_message)
    end

    return unless request.user_id.present?

    volunteer = User.find_by(id: request.user_id, role: 'volunteer')
    return unless volunteer

    Notification.create(user: volunteer, notifiable: request, message: volunteer_message)
  end
end
