class Admin::ShiftsController < ApplicationController

  before_filter :set_user, :only => [:index]

  def all_shifts
    @shifts = Shift.ordered
    @shift = Shift.new
  end

  def index
    @shifts = @user.shifts.ordered
    @shift = Shift.new
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = Shift.new(params[:shift])

    if @shift.save
      flash[:success] = "Shift accepted"
      redirect_to admin_shifts_path
    else
      @shifts = Shift.where('id IS NOT NULL')
      render 'index'
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    msg = 'shift was deleted successfuly'

    redirect_to admin_all_shifts_path, notice: msg
  end

  private

    def set_user
      @user = User.find params[:id]
    end

  # def check_current_user
  #   if params[:user_id]
  #     @user = User.find(params[:user_id])
  #     if @user != current_user
  #       flash.now[:error] = "You dont have permission to view other users shift"
  #       @user = current_user
  #     end
  #   end
  # end

end
