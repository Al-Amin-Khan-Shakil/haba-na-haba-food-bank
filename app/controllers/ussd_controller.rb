class UssdController < ApplicationController
  skip_before_action :verify_authenticity_token

  def recive
    response = UssdHandler.new(params).handle
    render plain: response
  end
end
