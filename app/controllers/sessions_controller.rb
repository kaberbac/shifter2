class SessionsController < ApplicationController
  skip_before_filter :sign_in_if_not_logged, :only => [:new, :create]
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if user.is_role?('admin')
        redirect_to admin_users_path
      else
        redirect_to user_shifts_path(user)
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
