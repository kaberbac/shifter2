class ShiftsController < ApplicationController

  def calendar
    # @shifts = Shift.order("day_work DESC")
    @shifts = Shift.order("day_work DESC").all.group_by(&:day_work)
  end

  def index
      @shifts = current_user.shifts
      @shift = Shift.new
  end

  def new
    @shift = Shift.new
  end

  def create
    @shift = current_user.shifts.new(params[:shift])
    if @shift.save
      flash[:success] = "Shift accepted"
      redirect_to user_shifts_path
    else
      @shifts = current_user.shifts.where('id IS NOT NULL')
      render 'index'
    end
  end

end
