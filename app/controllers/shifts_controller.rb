class ShiftsController < ApplicationController

  def calendar

    #@year_weeks is a hash with key as week number and value the corresponding day
    @year_weeks = {}
    (1..52).each do |w|
      @year_weeks['Week #' + w.to_s + ' Start : ' + (Date.today.beginning_of_year + (w-1)*7).to_s] = Date.today.beginning_of_year + (w-1)*7
    end

     #raise @year_weeks.inspect

    # if params[:selected_week].nil?
    #   params[:selected_week] = Date.today.beginning_of_week(:sunday)
    # end
    params[:selected_week] ||= Date.today.beginning_of_week(:sunday)

    week_first_day(params[:selected_week].to_date)

  end

  def week_first_day (date = Date.today.beginning_of_week(:sunday))
    @shifts = Shift.day_work_between(date, date+7).ordered.all.group_by(&:day_work)
    @week_business_days = date..(date+6)
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
    if Shift.shift_day_work(@shift.day_work).count == 2
      flash[:error] = "Maximum 2 shifts a day is allowed"
      redirect_to user_shifts_path
    else
      if @shift.save
        flash[:success] = "Shift accepted"
        redirect_to user_shifts_path
      else
        @shifts = current_user.shifts.where('id IS NOT NULL')
        render 'index'
      end
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    msg=''
    if @shift.user_id != current_user.id
      msg = 'You dont have permission to delete other users shifts'
    else if @shift.status != 'pending'
           msg = 'You can not delete approved or rejected status'
         else
           @shift.destroy
           msg = 'shift was deleted successfuly'
         end
    end
    redirect_to user_shifts_path(current_user.id), notice: msg
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
