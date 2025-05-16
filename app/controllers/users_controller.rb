class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]


  def index
    @users = FilterService.new(User.all, filter_params).apply
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(@user), notice: 'User was successfully created.'
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence.presence || 'There was an error creating the user.'
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence.presence || 'There was an error updating the user.'
      render :edit
    end
  end

  def destroy
    if @user == current_user
      flash[:alert] = 'You cannot delete your own account.'
    else
      @user.destroy
      flash[:notice] = 'User was successfully delete.'
    end

    redirect_to users_path
  end

  private
  
  def filter_params
    params.permit(:commit,:first_name, :phone_number, :gender,
                  :role, :last_name,
    )
  end
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, alert: 'User does not exist.'
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :profile_picture, :phone_number, :role, :gender, :address,
                                 :email, :password, :password_confirmation)
  end
end
