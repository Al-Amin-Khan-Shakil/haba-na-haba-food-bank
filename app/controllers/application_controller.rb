class ApplicationController < ActionController::Base

  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end
  def apply_filters(relation, filter_params)
    FilterService.new(relation, filter_params).apply
  end


end
