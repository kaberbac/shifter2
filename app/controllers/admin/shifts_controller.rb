class Admin::ShiftsController < Admin::BaseController

  before_filter :set_shift, :only => [:destroy, :approve, :reject, :become_pending]
  before_filter :set_shifts, :only => [:index, :destroy, :create, :approve, :reject, :become_pending]

  def trigger_outdater
    if ShiftOutdater.execute
      flash[:success] = 'Shift outdater has been triggered'
    else
      flash[:error] = 'No shift still pending in the past'
    end

    redirect_to admin_shifts_path
  end

  def approve
    check_change_status('approved')
  end

  def reject
    check_change_status('rejected')
  end

  def become_pending
    if current_user.is_admin?
      change_status('pending')
    else
      flash[:error] = 'Only admin can clear a shift decision'
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

  private

  def set_shift
    @shift = Shift.find(params[:id])
  end

  def set_shifts
    @shifts = Shift.ordered
  end

  def change_status(decision)
    if @shift.update_attributes(status: decision)
      flash[:success] = 'Shift updated successfuly'
    else
      flash[:error] = @shift.errors.full_messages.join('. ')
    end
  end

  def check_change_status(decision)
    if current_user.is_manager? && !current_user.is_admin?
      if current_user == @shift.user
        flash[:error] = 'You are not allowed to approve or reject your own shifts'
      else
        change_status(decision)
      end
    else if current_user.is_admin?
           change_status(decision)
         end
    end
    redirect_to admin_shifts_path
  end

end
