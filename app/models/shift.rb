class Shift < ActiveRecord::Base
  attr_accessible :day_work, :user_id

  belongs_to :user

  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day

  def not_past_date
    if self.day_work.past?
      errors.add(:date, 'date should be in future')
    end
  end

  def business_day
    if self.day_work.saturday? || self.day_work.sunday?
      errors.add(:date, 'date should be a business day (Monday to Friday)')
    end
  end


end
