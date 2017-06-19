class Admin::ShiftsController < ApplicationController

  before_filter :check_if_admin

  def index
    @shifts = Shift.ordered
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
    msg=''
    if @shift.status != 'pending'
      msg = 'You can not delete approved or rejected status'
    else
      @shift.destroy
      msg = 'shift was deleted successfuly'
    end

    redirect_to admin_shifts_path, notice: msg
  end

end
