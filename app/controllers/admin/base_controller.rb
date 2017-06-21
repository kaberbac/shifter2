class Admin::BaseController < ApplicationController
  before_filter :restrict_user_by_role

  # edit valid roles here
  VALID_ROLES = ['admin', 'manager']

  protected

  # redirect if user does not have a valid role
  def restrict_user_by_role
    unless current_user.has_role_in_roles_list?(VALID_ROLES)
      flash[:error] = 'You do not have permission to view this page'
      redirect_to root_path
    end
  end

end