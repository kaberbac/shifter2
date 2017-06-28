class Shift < ActiveRecord::Base
  attr_accessible :day_work, :user_id, :status
  MAX_SHIFTS_PER_DAY = 2
  belongs_to :user
  has_many :shift_decisions, dependent: :destroy

  STATUSES = %w(pending approved rejected outdated)

  before_destroy :check_before_delete_shift?

  before_validation(on: :create) do
    self.status ||= 'pending'
  end

  # scope :method_name, lambda { |variable| where(some_attribute: variable) }
  scope :ordered, order('day_work desc')
  scope :day_work_between, lambda { |start_date, end_date| where(day_work: start_date..end_date) }
  # return shifts for a given day_work
  scope :shifts_day_work, lambda { |day_chosen| where(day_work: day_chosen)}
  # return approved shifts for a given day
  scope :approved_shifts_day_work, lambda {|day_chosen| where(day_work: day_chosen, status: 'approved')}
  scope :with_status, lambda { |status| where(status: status) }

  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day
  validate :check_max_shift_per_day, on: :update, :if => :is_shift_approved?
  validate :check_traited_shift
  validates :status, presence: true, :inclusion=> { :in => STATUSES }
  

  def check_before_delete_shift?
    if !self.is_shift_pending? && !self.is_shift_outdated?
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

  def check_traited_shift # approved status cant be changed to rejected and vice versa, can only be changed to pending
    if self.status_changed?
      if self.day_work.past?
        self.errors[:base] = 'past shifts can be changed only to outdated'
      else if %w( approved rejected ).include?(self.status_was)
             if !self.is_shift_pending?
               self.errors[:base] = 'Approved/rejected shifts can only be reverted back to pending'
             end
           end
      end
      if self.status_was == 'outdated'
        self.errors[:base] = 'cant update outdated shift'
      end
    end
  end

  def not_past_date
    if self.status_was == 'pending' && self.is_shift_outdated? && self.day_work.past? && self.persisted?
      return true
    end
    if self.day_work.past?
      errors.add(:date, 'date should be in future')
    end
  end

  def check_max_shift_per_day
    # shifts_to_count = self.class.shifts_day_work(self.day_work) # shifts for a given day_work
    approved_shifts_to_count = self.class.approved_shifts_day_work(self.day_work) # approved shifts for a given day_work
    if approved_shifts_to_count.count >= MAX_SHIFTS_PER_DAY
      errors.add(:date, "Maximum " + MAX_SHIFTS_PER_DAY.to_s + " approved shifts per day is allowed")
    end
    return errors.blank?
  end

  def business_day
    if self.day_work.saturday? || self.day_work.sunday?
      errors.add(:date, 'date should be a business day (Monday to Friday)')
    end
  end

  def get_history_status
    ShiftDecision.history_status(self.id)
  end


end
