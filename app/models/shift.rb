class Shift < ActiveRecord::Base
  attr_accessible :day_work, :user_id, :status

  belongs_to :user

  STATUSES = %w(pending approved rejected)

  # scope :method_name, lambda { |variable| where(some_attribute: variable) }
  scope :ordered, order(:day_work)
  scope :day_work_between, lambda { |start_date, end_date| where(day_work: start_date..end_date) }

  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day
  validates :status, presence: true, :inclusion=> { :in => STATUSES }

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
