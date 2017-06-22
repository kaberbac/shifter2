class Shift < ActiveRecord::Base
  attr_accessible :day_work, :user_id, :status
  MAX_SHIFTS_PER_DAY = 2
  belongs_to :user

  STATUSES = %w(pending approved rejected outdated)

  before_destroy :check_shift_pending?

  before_validation(on: :create) do
    self.status ||= 'pending'
  end

  # scope :method_name, lambda { |variable| where(some_attribute: variable) }
  scope :ordered, order(:day_work)
  scope :day_work_between, lambda { |start_date, end_date| where(day_work: start_date..end_date) }
  # return shifts for a given day_work
  scope :shifts_day_work, lambda { |day_chosen| where(day_work: day_chosen)}
  scope :with_status, lambda { |status| where(status: status) }

  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day
  validate :check_max_shift_per_day
  validate :check_traited_shift
  validates :status, presence: true, :inclusion=> { :in => STATUSES }


  def check_shift_pending?
    if self.status != 'pending' && self.status != 'outdated'
      self.errors[:base] = 'You can delete only pending/outdated shifts'
      return false
    end
  end

  def is_shift_approved?
    self.status == 'approved'
  end

  def is_shift_rejected?
    self.status == 'rejected'
  end

  def is_shift_pending?
    self.status == 'pending'
  end

  def is_shift_outdated?
    self.status == 'outdated'
  end

  def check_traited_shift # approved status cant be changed to rejected and vice versa
    if [self.status_was, self.status] == ['approved', 'rejected'] || [self.status_was, self.status] == ['rejected', 'approved']
      self.errors[:base] = 'Approved status cant be changed to rejected and vice versa'
    end
    if self.status_was == self.status && self.persisted?
      self.errors[:base] = 'no change status have been detected'
    end
    if [self.status_was, self.status] == ['outdated', 'approved'] || [self.status_was, self.status] == ['outdated', 'rejected']
      self.errors[:base] = 'outdated status cant be approved or rejected and vice versa'
    end
  end

  def not_past_date
    if self.status_was == 'pending' && self.status == 'outdated' && self.day_work.past? && self.persisted?
      return true
    end
    if self.day_work.past?
      errors.add(:date, 'date should be in future')
    end
  end

  def check_max_shift_per_day
    shifts_to_count = self.class.shifts_day_work(self.day_work) # shifts for a given day_work
    shifts_to_count = shifts_to_count.where("id != ?", self.id) if self.persisted? # in case of update, we dont count current shift

    if shifts_to_count.count >= MAX_SHIFTS_PER_DAY
      errors.add(:date, "Maximum " + MAX_SHIFTS_PER_DAY.to_s + " shifts per day is allowed")
    end
  end

  def business_day
    if self.day_work.saturday? || self.day_work.sunday?
      errors.add(:date, 'date should be a business day (Monday to Friday)')
    end
  end


end
