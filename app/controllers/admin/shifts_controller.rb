class Admin::ShiftsController < ApplicationController

  before_filter :check_if_admin
  before_filter :set_shifts, :only => [:index, :destroy, :create]
  before_filter :set_shift, :only => [:destroy]

  def index
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
    if @shift.destroy
      flash[:success] = 'shift was deleted successfuly'
    else
      flash[:error] = @shift.errors.full_messages.join('. ')
    end
    redirect_to admin_shifts_path
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def set_shifts
    @shifts = Shift.ordered
  end


end
