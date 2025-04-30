class RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[show edit update destroy]

  def index
    @requests = Request.all
  end

  def show; end

  def new
    @request = Request.new
    @request.build_donation
  end

  def create
    @request = Request.new(request_params)

    if @request.donation_request?
      @request.donation.donor_name = @request.name
      @request.donation.phone_number = @request.phone_number
    end

    if @request.save
      redirect_to @request, notice: 'Request was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @request.build_donation if @request.donation_request? && @request.donation.nil?
  end

  def update
    if @request.update(request_params)
      if @request.donation_request? && @request.donation.present?
        # Update donor info from request
        @request.donation.update(
          donor_name: @request.name,
          phone_number: @request.phone_number
        )
      end
      redirect_to @request, notice: 'Request updated successfully'
    else
      # Ensure donation is built for the form if validation fails
      @request.build_donation if @request.donation_request? && @request.donation.blank?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    redirect_to requests_path, notice: 'Request was successfully destroyed.'
  end

  private

  def set_request
    @request = Request.includes(:donation).find(params[:id])
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
      donation_attributes: [:id, :donation_type, :donation_name, :amount, :_destroy]
    )
  end
end
