class Shift < ActiveRecord::Base

  # will_paginate how many items shown per page
  self.per_page = 10

  attr_accessible :day_work, :user_id, :status

  # constants
  MAX_SHIFTS_PER_DAY = 2
  MAX_USER_SHIFTS_PER_WEEK = 3
  STATUSES = %w(pending approved rejected outdated)

  # relations
  belongs_to :user
  has_many :shift_decisions, dependent: :destroy

  # scopes
  scope :ordered, order('day_work desc')
  # scope :method_name, lambda { |variable| where(some_attribute: variable) }
  scope :day_work_between, lambda { |start_date, end_date| where(day_work: start_date..end_date) }
  # return shifts for a given day_work
  scope :shifts_day_work, lambda { |day_chosen| where(day_work: day_chosen)}
  # return approved shifts for a given day
  scope :approved_shifts_day_work, lambda {|day_chosen| where(day_work: day_chosen, status: 'approved')}

  # return approved user shifts for the week that includes a given day
  scope :approved_user_shifts_week, lambda {|u_id, day_chosen| where("user_id = ? AND status = 'approved' AND day_work >= ? AND day_work <= ?", u_id, day_chosen.to_date.beginning_of_week(:sunday), day_chosen.to_date.beginning_of_week(:sunday) + 7)}
  scope :with_status, lambda { |status| where(status: status) }

  # validations
  validates :user, presence: true
  validates :day_work, presence: true
  validates :day_work, :uniqueness => {:scope => :user_id}
  validate :not_past_date
  validate :business_day
  validate :check_max_shift_per_day, on: :update, :if => :is_shift_approved?
  validate :check_max_user_shifts_per_week, on: :update, :if => :is_shift_approved?
  validate :check_traited_shift
  validates :status, presence: true, :inclusion=> { :in => STATUSES }

  # callbacks
  before_destroy :deletable?
  before_validation(on: :create) do
    self.status ||= 'pending'
  end


  def deletable?
    if self.has_decision?
      self.errors[:base] = 'You can delete only pending/outdated shifts'
      return false
    end
  end

  def can_be_traited?
    self.is_shift_pending? && !self.day_work.past?
  end

  def has_decision?
    self.is_shift_approved? || self.is_shift_rejected?
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
      if self.day_work.past? && !self.is_shift_outdated?
        self.errors[:base] = 'past shifts can be changed only to outdated'
      elsif %w( approved rejected ).include?(self.status_was) && !self.is_shift_pending?
        self.errors[:base] = 'Approved/rejected shifts can only be reverted back to pending'
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

  def check_max_user_shifts_per_week
    # raise self.class.week_days_for_given_day(self.day_work).inspect
     approved_user_shifts_to_count = self.class.approved_user_shifts_week(self.user.id, self.day_work) # approved user shifts in a week that include day_work
     if approved_user_shifts_to_count.count >= MAX_USER_SHIFTS_PER_WEEK
       errors.add(:date, "Maximum " + MAX_USER_SHIFTS_PER_WEEK.to_s + " approved shifts per week per user is allowed")
     end
     return errors.blank?
  end

  def business_day
    if self.day_work.saturday? || self.day_work.sunday?
      errors.add(:date, 'date should be a business day (Monday to Friday)')
    end
  end


end
