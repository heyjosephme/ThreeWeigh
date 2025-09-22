class WeightAnalyticsService
  def initialize(user)
    @user = user
    @weight_entries = user.weight_entries.order(:date)
  end

  def calculate_analytics
    return insufficient_data_response if @weight_entries.count < 2

    {
      # Basic stats
      current_weight: current_weight,
      weight_change: weight_change,
      total_entries: @weight_entries.count,

      # Averages and trends
      seven_day_average: seven_day_average,
      thirty_day_average: thirty_day_average,
      weight_trend: weight_trend,

      # Records and velocity
      lowest_weight: lowest_weight,
      highest_weight: highest_weight,
      weight_velocity: weight_velocity,

      # BMI calculations
      current_bmi: current_bmi,
      bmi_category: bmi_category,

      # Chart data
      chart_data: chart_data,
      trend_data: trend_data,

      # Insights
      best_week: best_week,
      worst_week: worst_week,
      consistency_score: consistency_score,

      # Goal tracking (placeholder for future feature)
      goal_weight: nil,
      goal_progress: nil
    }
  end

  private

  def insufficient_data_response
    {
      insufficient_data: true,
      total_entries: @weight_entries.count,
      message: "Need at least 2 weight entries to show analytics"
    }
  end

  def current_weight
    @weight_entries.last&.weight
  end

  def weight_change
    return 0 if @weight_entries.count < 2
    current_weight - @weight_entries.first.weight
  end

  def seven_day_average
    recent_entries = @weight_entries.where("date >= ?", 7.days.ago)
    return nil if recent_entries.empty?
    recent_entries.average(:weight).to_f.round(1)
  end

  def thirty_day_average
    recent_entries = @weight_entries.where("date >= ?", 30.days.ago)
    return nil if recent_entries.empty?
    recent_entries.average(:weight).to_f.round(1)
  end

  def weight_trend
    return "stable" if @weight_entries.count < 5

    recent_weights = @weight_entries.last(5).pluck(:weight)
    first_half = recent_weights.first(3).sum / 3.0
    second_half = recent_weights.last(3).sum / 3.0

    diff = second_half - first_half

    if diff > 0.5
      "increasing"
    elsif diff < -0.5
      "decreasing"
    else
      "stable"
    end
  end

  def lowest_weight
    {
      weight: @weight_entries.minimum(:weight),
      date: @weight_entries.find_by(weight: @weight_entries.minimum(:weight))&.date
    }
  end

  def highest_weight
    {
      weight: @weight_entries.maximum(:weight),
      date: @weight_entries.find_by(weight: @weight_entries.maximum(:weight))&.date
    }
  end

  def weight_velocity
    return 0 if @weight_entries.count < 2

    first_entry = @weight_entries.first
    last_entry = @weight_entries.last

    days_diff = (last_entry.date - first_entry.date).to_i
    return 0 if days_diff == 0

    weight_diff = last_entry.weight - first_entry.weight
    weekly_velocity = (weight_diff / days_diff) * 7

    weekly_velocity.round(2)
  end

  def current_bmi
    return nil unless current_weight && @user.respond_to?(:height) && @user.height.present?

    height_in_meters = @user.height / 100.0 # assuming height is stored in cm
    bmi = current_weight / (height_in_meters ** 2)
    bmi.round(1)
  end

  def bmi_category
    return nil unless current_bmi

    case current_bmi
    when 0..18.5
      "underweight"
    when 18.5..25
      "normal"
    when 25..30
      "overweight"
    else
      "obese"
    end
  end

  def chart_data
    @weight_entries.map do |entry|
      {
        date: entry.date.strftime("%Y-%m-%d"),
        weight: entry.weight,
        formatted_date: entry.date.strftime("%b %d")
      }
    end
  end

  def trend_data
    return [] if @weight_entries.count < 7

    # Calculate 7-day moving average
    trend_points = []
    @weight_entries.each_with_index do |entry, index|
      if index >= 6 # We have at least 7 data points
        recent_weights = @weight_entries[index-6..index].pluck(:weight)
        avg_weight = recent_weights.sum / recent_weights.size.to_f

        trend_points << {
          date: entry.date.strftime("%Y-%m-%d"),
          trend_weight: avg_weight.round(1),
          formatted_date: entry.date.strftime("%b %d")
        }
      end
    end

    trend_points
  end

  def best_week
    return nil if @weight_entries.count < 14

    weekly_changes = calculate_weekly_changes
    best = weekly_changes.min_by { |week| week[:change] }

    return best if best[:change] < 0 # Only return if it's weight loss
    nil
  end

  def worst_week
    return nil if @weight_entries.count < 14

    weekly_changes = calculate_weekly_changes
    worst = weekly_changes.max_by { |week| week[:change] }

    return worst if worst[:change] > 0 # Only return if it's weight gain
    nil
  end

  def calculate_weekly_changes
    changes = []
    current_date = @weight_entries.first.date
    end_date = @weight_entries.last.date

    while current_date <= end_date - 7.days
      week_start = current_date
      week_end = current_date + 7.days

      start_weight = weight_at_date(week_start)
      end_weight = weight_at_date(week_end)

      if start_weight && end_weight
        changes << {
          start_date: week_start,
          end_date: week_end,
          change: end_weight - start_weight,
          start_weight: start_weight,
          end_weight: end_weight
        }
      end

      current_date += 7.days
    end

    changes
  end

  def weight_at_date(target_date)
    # Find the closest weight entry to the target date
    closest_entry = @weight_entries.min_by { |entry| (entry.date - target_date).abs }
    return nil if (closest_entry.date - target_date).abs > 3.days # Don't extrapolate beyond 3 days

    closest_entry.weight
  end

  def consistency_score
    return 0 if @weight_entries.count < 7

    # Calculate how consistently the user logs weight (in last 30 days)
    thirty_days_ago = 30.days.ago.to_date
    recent_entries = @weight_entries.where("date >= ?", thirty_days_ago)

    days_with_entries = recent_entries.count
    possible_days = [ 30, (Date.current - thirty_days_ago).to_i ].min

    consistency = (days_with_entries.to_f / possible_days * 100).round(1)

    # Cap at 100% for daily logging
    [ consistency, 100.0 ].min
  end
end
