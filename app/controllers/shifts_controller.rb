class ShiftsController < ApplicationController



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
        render 'new'
      end
    else
      redirect_to signin_path
    end
  end

end
