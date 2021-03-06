class ShiftsController < ApplicationController

  before_filter :set_shifts, :only => [:index, :destroy, :create]
  before_filter :set_shift, :only => [:destroy]



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
    @shifts = current_user.shifts.ordered.paginate(page: params[:shifts_page])
    @shift = Shift.new
    @shift_request = ShiftRequest.new
    @shift_requests = current_user.shift_requests.where(status: 'requested')
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
      @shifts = current_user.shifts.where('id IS NOT NULL').paginate(page: params[:shifts_page])
      render 'index'
    end
  end

  def destroy
    if @shift.user_id != current_user.id
      flash[:error] = 'You dont have permission to delete other users shifts'

    else  if @shift.destroy
            flash[:success] = 'shift was deleted successfuly'
          else
            flash[:error] = @shift.errors.full_messages.join('. ')
          end
      redirect_to user_shifts_path(current_user.id)
    end

  end

  private

  def set_shifts
    @shifts = current_user.shifts.ordered
  end

  def set_shift
    @shift = Shift.find(params[:id])
  end

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
