class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[edit update destroy]
  before_action :set_form_dependencies, only: %i[new edit create update]
  load_and_authorize_resource

  def index
    filter_applied = filter_params.except(:commit).reject { |_, v| v.blank? }.present?

    base_query = Event.accessible_by(current_ability)

    if filter_applied
      @events = FilterService.new(base_query, filter_params).apply.order(created_at: :desc)
    else
      default_params = filter_params.merge(start_date: 3.days.ago.to_date.to_s, end_date: 7.days.from_now.to_date.to_s)
      @events = FilterService.new(base_query, default_params).apply.order(created_at: :desc)
    end
    @districts = District.all
    @counties = County.all
    @sub_counties = SubCounty.all
  end

  def show
    @event = Event.includes(event_users: :user).find(params[:id])
    @event_users = @event.event_users.distinct || []
    @individual_beneficiaries = @event.individual_beneficiaries
    @family_beneficiaries = @event.family_beneficiaries
    @organization_beneficiaries = @event.organization_beneficiaries
    @inventories = @event.inventories
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

  def filter_params
    params.permit(:title, :start_date, :end_date,
                  :district_id, :county_id, :sub_county_id, :commit)
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
      event_user = event.event_users.find_or_create_by(user_id: user_id)
      next unless event_user.persisted?

      date_str = event.start_date.strftime('%B %d, %Y at %I:%M %p')

      user = User.find(user_id)
      Notification.create(
        user: user,
        notifiable: event,
        message: "You’ve been invited to the event \"#{event.title}\" scheduled for #{date_str}."
      )
    end
  end
end
