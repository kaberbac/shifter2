class ShiftRequestsController < ApplicationController
  before_filter :set_shift_request

  def accepte
    @shift = Shift.new(day_work: @shift_request.day_work, user_id: @shift_request.user_id,status: 'approved', workplace_id:@shift_request.workplace_id)
    if @shift.save(day_work: @shift_request.day_work, user_id: @shift_request.user_id,status: 'approved', workplace_id:@shift_request.workplace_id)
      @shift_request.update_attributes(status: 'accepted')
      flash[:success] = "#{@shift_request.day_work} shift is confirmed"
    elsif
      flash[:error] = "Failed to confirm #{@shift_request.day_work} shift" + '---' + @shift.errors.full_messages.join('. ')
    end
    redirect_to(:back)
  end

  def refuse
    @shift_request.update_attributes(status: 'refused')
    flash[:success] = "#{@shift_request.day_work} shift is refused"
    redirect_to(:back)
  end

  def set_shift_request
    @shift_request = ShiftRequest.find(params[:id])
  end
end