class Admin::ShiftsController < Admin::BaseController

  before_filter :set_shift, :only => [:destroy, :update_status, :shift_update]
  before_filter :set_shifts, :only => [:index, :destroy, :create, :update_status]

  def trigger_outdater
    if ShiftOutdater.execute
      flash[:success] = 'Shift outdater has been triggered'
    else
      flash[:error] = 'No shift still pending in the past'
    end

    redirect_to admin_shifts_path
  end

  def update_status
    if current_user.is_manager? && current_user.id != @shift.user_id || current_user.is_admin?
      if !current_user.is_admin? && (@shift.is_shift_approved? || @shift.is_shift_rejected?)
        flash[:error] = 'You are not allowed to clear approved/rejected shift'
      else
        shift_update
      end
    else
      flash[:error] = 'You are not allowed to approve or reject your own shifts'
    end


    redirect_to admin_shifts_path
  end

  def index
    @shift = Shift.new
  end

  def destroy
    if current_user.is_admin? || current_user.id == @shift.user_id
      if @shift.destroy
        flash[:success] = 'shift was deleted successfuly'
      else
        flash[:error] = @shift.errors.full_messages.join('. ')
      end
    else
      flash[:error] = 'You are not allowed to delete other pending/outdated shifts'
    end

    redirect_to admin_shifts_path
  end

  def shift_update
    if @shift.update_attributes(status: params[:status])
      flash[:success] = 'Shift updated successfuly'
    else
      flash[:error] = @shift.errors.full_messages.join('. ')
    end
  end

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def set_shifts
    @shifts = Shift.ordered
  end


end
