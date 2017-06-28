class SessionsController < ApplicationController
  skip_before_filter :sign_in_if_not_logged, :only => [:new, :create]
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.is_inactive?
        flash[:error] = 'inactive account, you cant signin'
        redirect_to signin_path
      else
        sign_in user
        if user.has_role_in_roles_list?(Admin::BaseController::ADMINISTRATION_ROLES)
          redirect_to admin_users_path
        else
          redirect_to user_shifts_path(user)
        end
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end
end
