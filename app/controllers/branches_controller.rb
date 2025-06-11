class BranchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_branch, only: %i[show edit update destroy]

  def index
    @branches = Branch.all
  end

  def show; end

  def new
    @branch = Branch.new
    @unassigned_districts = District.where(branch_id: nil)
    @unassigned_users = User.where(branch_id: nil)
  end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      assign_districts
      assign_users
      redirect_to @branch, notice: 'Branch was successfully created.'
    else
      @unassigned_districts = District.where(branch_id: nil)
      @unassigned_users = User.where(branch_id: nil)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @unassigned_districts = District.where(branch_id: nil).or(District.where(branch_id: @branch.id))
    @unassigned_users = User.where(branch_id: nil).or(User.where(branch_id: @branch.id))

  end

  def update
    if @branch.update(branch_params)
      assign_districts
      assign_users
      redirect_to @branch, notice: 'Branch was successfully updated.'
    else
      @unassigned_districts = District.where(branch_id: nil).or(District.where(branch_id: @branch.id))
      @unassigned_users = User.where(branch_id: nil).or(User.where(branch_id: @branch.id))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy
    redirect_to branches_path, notice: 'Branch was successfully destroyed.'
  end

  private

  def set_branch
    @branch = Branch.find(params[:id])
  end

  def branch_params
    params.require(:branch).permit(:name, :phone_number, :address, district_ids: [], user_ids: [])
  end

  def assign_districts
    District.where(branch_id: @branch.id).update_all(branch_id: nil)

    return unless params[:branch][:district_ids]

    District.where(id: params[:branch][:district_ids].reject(&:blank?)).update_all(branch_id: @branch.id)
  end
def assign_users
  User.where(branch_id: @branch.id).update_all(branch_id: nil)

  return unless params[:branch][:user_ids]

  User.where(id: params[:branch][:user_ids].reject(&:blank?)).update_all(branch_id: @branch.id)
end
end
