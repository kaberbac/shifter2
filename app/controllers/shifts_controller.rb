class ShiftsController < ApplicationController

  def calendar

    #@year_weeks is a hash with key as week number and value the corresponding day
    @year_weeks = {}
    (1..52).each do |w|
      @year_weeks[w] = Date.today.beginning_of_year + (w-1)*7
    end

    raise @year_weeks.inspect
    date = Date.today.beginning_of_week
    @shifts = Shift.where(:day_work => date..(date+5)).order("day_work ASC").all.group_by(&:day_work)
    @week_business_days = date..(date+4)
  end

  def index
    check_current_user
    @shifts = current_user.shifts.order("day_work ASC")
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

  private

  def check_current_user
    if params[:user_id]
      @user = User.find(params[:user_id])
      if @user != current_user
        flash.now[:error] = "You dont have permission to view other users shift"
        @user = current_user
      end
    end
  end

end
