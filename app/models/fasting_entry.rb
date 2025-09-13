class FastingEntry < ApplicationRecord
  belongs_to :user

  # Status enum
  STATUSES = %w[active completed broken].freeze
  
  validates :start_time, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :planned_duration, presence: true, numericality: { greater_than: 0 }
  
  # Scopes
  scope :recent, -> { order(start_time: :desc) }
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :broken, -> { where(status: 'broken') }
  scope :for_period, ->(start_date, end_date) { where(start_time: start_date.beginning_of_day..end_date.end_of_day) }

  # Instance methods
  def active?
    status == 'active'
  end

  def completed?
    status == 'completed'
  end

  def broken?
    status == 'broken'
  end

  def duration_minutes
    return 0 unless end_time
    ((end_time - start_time) / 1.minute).round
  end

  def current_duration_minutes
    return 0 unless start_time
    end_time_or_now = end_time || Time.current
    ((end_time_or_now - start_time) / 1.minute).round
  end

  def planned_duration_hours
    planned_duration / 60.0 if planned_duration
  end

  def duration_hours
    duration_minutes / 60.0
  end

  def current_duration_hours
    current_duration_minutes / 60.0
  end

  def progress_percentage
    return 0 unless planned_duration&.positive?
    [(current_duration_minutes.to_f / planned_duration * 100).round(1), 100].min
  end

  def remaining_minutes
    return 0 unless planned_duration && active?
    [planned_duration - current_duration_minutes, 0].max
  end

  def time_remaining_text
    return "Completed" unless active?
    
    remaining = remaining_minutes
    return "Goal reached!" if remaining <= 0
    
    hours = remaining / 60
    minutes = remaining % 60
    
    if hours > 0
      "#{hours}h #{minutes}m remaining"
    else
      "#{minutes}m remaining"
    end
  end

  def duration_text
    minutes = current_duration_minutes
    hours = minutes / 60
    mins = minutes % 60
    
    if hours > 0
      "#{hours}h #{mins}m"
    else
      "#{mins}m"
    end
  end

  # Class methods
  def self.current_active_fast(user)
    user.fasting_entries.active.order(start_time: :desc).first
  end

  def self.start_fast!(user, planned_duration_minutes, notes = nil)
    # End any currently active fasts
    user.fasting_entries.active.update_all(status: 'broken', end_time: Time.current)
    
    # Create new fast
    create!(
      user: user,
      start_time: Time.current,
      planned_duration: planned_duration_minutes,
      status: 'active',
      notes: notes
    )
  end

  def complete!
    update!(status: 'completed', end_time: Time.current)
  end

  def break!
    update!(status: 'broken', end_time: Time.current)
  end
end
