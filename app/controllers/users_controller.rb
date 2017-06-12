class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Shifter2!"
      redirect_to user_shifts_path
    else
      render 'new'
    end

  end

  def show
    if signed_in?
      @user = User.find(params[:id])
    else
      redirect_to signin_path
    end
  end

end
