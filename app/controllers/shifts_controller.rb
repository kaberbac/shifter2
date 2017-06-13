class ShiftsController < ApplicationController

  def calendar
    # @shifts = Shift.order("day_work DESC")
    @shifts = Shift.order("day_work DESC").all.group_by(&:day_work)
  end

  def index
    if signed_in?
      @shifts = current_user.shifts
      @shift = Shift.new
    else
      redirect_to signin_path
    end

  end

  def new
    @shift = Shift.new
  end

  def create
    if signed_in?
      @shift = current_user.shifts.new(params[:shift])
      if @shift.save
        flash[:success] = "Shift accepted"
        redirect_to user_shifts_path
      else
        @shifts = current_user.shifts.where(:id.present?)
        render 'index'
      end
    else
      redirect_to signin_path
    end
  end

end
