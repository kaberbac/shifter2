class Admin::ShiftsController < Admin::BaseController

  before_filter :set_shift, :only => [:destroy, :approve, :reject, :become_pending]
  before_filter :set_shifts, :only => [:index, :destroy, :approve, :reject, :become_pending]
  before_filter :check_can_change_status, :only => [:approve, :reject]

  def trigger_outdater
    if ShiftOutdater.execute
      flash[:success] = 'Shift outdater has been triggered'
    else
      flash[:error] = 'No shift still pending in the past'
    end

    redirect_to admin_shifts_path
  end

  def index
    @shift = Shift.new
    @shiftdecisions = ShiftDecision.ordered
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

  def approve
    change_status('approved')
    redirect_to admin_shifts_path
  end

  def reject
    change_status('rejected')
    redirect_to admin_shifts_path
  end

  def become_pending
    if current_user.is_admin?
      change_status('pending')
    else
      flash[:error] = 'Only admin can clear a shift decision'
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

  def check_can_change_status
    if current_user.is_manager? && current_user == @shift.user
      flash[:error] = 'You are not allowed to approve or reject your own shifts'
      redirect_to admin_shifts_path
      return false
    end
  end

  def change_status(decision)
    if @shift.update_attributes(status: decision)
      flash[:success] = 'Shift updated successfuly'
      ShiftDecision.create!(shift_id: @shift.id, user_id: current_user.id, decision: decision)
    else
      flash[:error] = @shift.errors.full_messages.join('. ')
    end
  end

end
