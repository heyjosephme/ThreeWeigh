class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :lockable

  has_many :weight_entries, dependent: :destroy
  has_many :fasting_entries, dependent: :destroy

  # Profile validations
  validates :unit_system, presence: true, inclusion: { in: %w[metric imperial] }
  validates :height, numericality: { greater_than: 0, less_than: 300 }, allow_nil: true
  validates :age, numericality: { greater_than: 0, less_than: 150 }, allow_nil: true
  validates :gender, inclusion: { in: %w[male female other] }, allow_nil: true
  validates :goal_weight, numericality: { greater_than: 0, less_than: 500 }, allow_nil: true
  validates :activity_level, inclusion: { in: %w[sedentary light moderate active very_active] }, allow_nil: true

  # Unit system helpers
  UNIT_SYSTEMS = %w[metric imperial].freeze
  GENDERS = %w[male female other].freeze
  ACTIVITY_LEVELS = %w[sedentary light moderate active very_active].freeze

  def latest_weight
    weight_entries.recent.first
  end

  def weight_trend(days = 30)
    weight_entries.for_period(days.days.ago.to_date, Date.current)
  end

  def current_fast
    fasting_entries.active.order(start_time: :desc).first
  end

  def fasting_streak
    # Count consecutive days with completed fasts
    recent_fasts = fasting_entries.completed.recent.limit(30)
    streak = 0
    current_date = Date.current

    recent_fasts.each do |fast|
      if fast.start_time.to_date == current_date
        streak += 1
        current_date -= 1.day
      else
        break
      end
    end

    streak
  end

  # Weight logging streak methods
  def weight_logging_streak
    # Fetch recent dates in one query (optimized)
    recent_dates = weight_entries
      .where("date >= ?", 1.year.ago)
      .order(date: :desc)
      .pluck(:date)

    return 0 if recent_dates.empty?

    # Calculate consecutive days from today
    streak = 0
    current_date = Date.current

    recent_dates.each do |entry_date|
      break if entry_date != current_date
      streak += 1
      current_date -= 1.day
    end

    streak
  end

  def longest_weight_logging_streak
    # Calculate the longest streak in history
    all_dates = weight_entries.order(:date).pluck(:date)
    return 0 if all_dates.empty?

    max_streak = 0
    current_streak = 1

    all_dates.each_cons(2) do |prev_date, curr_date|
      if (curr_date - prev_date).to_i == 1
        current_streak += 1
        max_streak = [max_streak, current_streak].max
      else
        current_streak = 1
      end
    end

    [max_streak, current_streak].max
  end

  def weight_logging_heatmap_data(days = 365)
    # For GitHub-style activity heatmap
    start_date = days.days.ago.to_date

    # Single query to get all logged dates
    logged_dates = weight_entries
      .where("date >= ?", start_date)
      .pluck(:date)
      .to_set # Fast O(1) lookups

    # Build heatmap data array
    (start_date..Date.current).map do |date|
      {
        date: date.to_s,
        logged: logged_dates.include?(date),
        count: logged_dates.include?(date) ? 1 : 0
      }
    end
  end

  def logged_weight_today?
    weight_entries.exists?(date: Date.current)
  end

  # Profile completeness
  def profile_complete?
    height.present? && goal_weight.present?
  end

  def profile_completion_percentage
    total_fields = 4 # height, age, gender, goal_weight
    completed_fields = [height, age, gender, goal_weight].count(&:present?)
    (completed_fields.to_f / total_fields * 100).round
  end

  # Unit conversion methods
  def height_in_display_unit
    return nil unless height.present?

    if unit_system == 'imperial'
      # Convert cm to ft-in
      total_inches = (height / 2.54).round
      feet = total_inches / 12
      inches = total_inches % 12
      "#{feet}'#{inches}\""
    else
      "#{height.to_i} cm"
    end
  end

  def goal_weight_in_display_unit
    return nil unless goal_weight.present?

    if unit_system == 'imperial'
      "#{(goal_weight * 2.20462).round(1)} lbs"
    else
      "#{goal_weight} kg"
    end
  end

  # BMI calculation
  def bmi
    return nil unless height.present? && latest_weight&.weight.present?

    height_in_meters = height / 100.0
    current_weight_kg = latest_weight.weight

    bmi_value = current_weight_kg / (height_in_meters ** 2)
    bmi_value.round(1)
  end

  def bmi_category
    return nil unless bmi.present?

    case bmi
    when 0..18.5
      'underweight'
    when 18.5..25
      'normal'
    when 25..30
      'overweight'
    else
      'obese'
    end
  end
end
