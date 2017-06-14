class UsersController < ApplicationController
  skip_before_filter :sign_in_if_not_logged, :only => [:new, :create, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Shifter2!"
      redirect_to user_shifts_path(@user)
    else
      render 'new'
    end
  end

  def edit
    check_current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      cookies.permanent[:remember_token] = @user.remember_token
      flash[:success] = "Update succeeded!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    check_current_user
  end

  private

  def check_current_user
    @user = User.find(params[:id])
    if @user != current_user
      flash.now[:error] = "You dont have permission to view/edit other users profile"
      @user = current_user
    end
  end

end
