module ShiftOutdater
  def self.execute
    shifts_to_outdate = Shift.with_status(:pending).where('day_work < ?', Date.current)

    shifts_to_outdate.each do |shift|
      shift.update_attributes!(status: 'outdated')
    end
    return shifts_to_outdate.present?
  end
end