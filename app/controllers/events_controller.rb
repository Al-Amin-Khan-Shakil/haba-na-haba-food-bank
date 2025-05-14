class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]

  def index
    @events = Event.all
  end

  def show
    @event = Event.includes(event_users: :user).find(params[:id])
    @event_users = @event.event_users.distinct || []
    @individual_beneficiaries = @event.individual_beneficiaries
    @family_beneficiaries = @event.family_beneficiaries
    @organization_beneficiaries = @event.organization_beneficiaries
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      allocate_users_to_event(@event, params[:event][:user_ids])
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
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

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :district_id, :county_id,
                                  :sub_county_id, user_ids: [])
  end

  def set_form_dependencies
    @users = User.all
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
  end

  def allocate_users_to_event(event, user_ids)
    return if user_ids.nil? || user_ids.empty?

    user_ids.each do |user_id|
      event.event_users.find_or_create_by(user_id: user_id)
    end
  end
end
