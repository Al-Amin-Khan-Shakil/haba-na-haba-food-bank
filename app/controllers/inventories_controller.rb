class InventoriesController < ApplicationController
  before_action :authenticate_user!

  private

  def set_inventory
    if params[:request_id]
      @request = Request.find(params[:request_id])
      @inventory = @request.inventory
    else
      @inventory = Inventory.find(params[:id])
      @request = @inventory.request
    end
  end
end
