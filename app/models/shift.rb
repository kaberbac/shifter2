class Shift < ActiveRecord::Base
  attr_accessible :day_work, :user_id, :status
  MAX_SHIFTS_PER_DAY = 2
  belongs_to :user

  STATUSES = %w(pending approved rejected)

  before_destroy :is_shift_pending?

  before_validation(on: :create) do
    self.status ||= 'pending'
  end

  # scope :method_name, lambda { |variable| where(some_attribute: variable) }
  scope :ordered, order(:day_work)
  scope :day_work_between, lambda { |start_date, end_date| where(day_work: start_date..end_date) }
  # return shifts for a given day_work
  scope :shift_day_work, lambda { |day_chosen| where(day_work: day_chosen)}

  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day
  validate :check_max_shift_per_day
  validates :status, presence: true, :inclusion=> { :in => STATUSES }


  def is_shift_pending?
    if self.status != 'pending'
      self.errors[:base] = 'You can delete only pending shifts'
      return false
    end
  end

  def not_past_date
    if self.day_work.past?
      errors.add(:date, 'date should be in future')
    end
  end

  def check_max_shift_per_day
    if self.class.shift_day_work(self.day_work).count >= MAX_SHIFTS_PER_DAY
      errors.add(:date, "Maximum " + MAX_SHIFTS_PER_DAY.to_s + " shifts per day is allowed")
    end
  end

  def business_day
    if self.day_work.saturday? || self.day_work.sunday?
      errors.add(:date, 'date should be a business day (Monday to Friday)')
    end
  end


end
