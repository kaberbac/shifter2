class UsersController < ApplicationController
  skip_before_filter :sign_in_if_not_logged, :only => [:new, :create, :update]

  def change_locale
    locale = params[:locale].to_s.strip.to_sym
    locale = I18n.default_locale unless I18n.available_locales.include?(locale)
    cookies.permanent[:my_locale] = locale
    redirect_to request.referer || root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to Shifter2!'
      redirect_to user_shifts_path(@user)
    else
      render 'new'
    end
  end

  def passwordchange
    @user = current_user

  end

  def edit
    check_current_user
  end

  def update
    @user = current_user

    if params[:user][:old_password] || params[:user][:password] || params[:user][:password_confirmation]
      if @user.authenticate(params[:user][:old_password])
        user_update(params[:user].except(:old_password), 'Password change succeeded!', 'passwordchange' )
      else
        flash.now[:error] = 'Old password not valid!'
        render 'passwordchange'
      end
    else
      user_update(params[:user], 'Update succeeded!', 'edit' )
    end
  end


  def show
    check_current_user
  end

  private

  def check_current_user
    @user = User.find(params[:id])
    if @user != current_user
      flash.now[:error] = 'You dont have permission to view/edit other users profile'
      @user = current_user
    end
  end

  def user_update(params, msg, goto )
    if @user.update_attributes(params)
      cookies.permanent[:remember_token] = @user.remember_token
      flash[:success] = msg
      redirect_to user_path(@user)
    else
      render goto
    end
  end

end
