class UsersController < ApplicationController
  skip_before_filter :sign_in_if_not_logged, :only => [:new, :create]

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
    @user = current_user
  end

  def update
    current_user.update_attributes(params[:user])
    if current_user.save
      flash[:success] = "Update succeeded!"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    if @user != current_user
      flash.now[:error] = "You dont have permission to view other users profile"
      @user = current_user
    end
  end

end
