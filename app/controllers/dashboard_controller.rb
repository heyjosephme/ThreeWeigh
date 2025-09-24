class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @latest_weight = current_user.latest_weight
    @new_weight_entry = current_user.weight_entries.build(date: Date.current)

    # Calculate basic weight stats
    @total_entries = current_user.weight_entries.count
    @weight_trend = calculate_weight_trend

    # Fasting data for dashboard
    @current_fast = current_user.current_fast
    @fasting_stats = calculate_fasting_stats

    # Prepare chart data (last 30 days)
    prepare_chart_data
  end

  private

  def calculate_weight_trend
    return nil if @total_entries < 2

    recent_entries = current_user.weight_entries.recent.limit(2)
    return nil if recent_entries.count < 2

    latest = recent_entries.first.weight
    previous = recent_entries.second.weight
    latest - previous
  end

  def calculate_fasting_stats
    total_fasts = current_user.fasting_entries.count
    completed_fasts = current_user.fasting_entries.completed.count
    current_streak = calculate_fasting_streak
    recent_fasts = current_user.fasting_entries.recent.limit(3)

    {
      total_fasts: total_fasts,
      completed_fasts: completed_fasts,
      current_streak: current_streak,
      recent_fasts: recent_fasts,
      completion_rate: total_fasts > 0 ? (completed_fasts.to_f / total_fasts * 100).round(1) : 0
    }
  end

  def calculate_fasting_streak
    # Calculate current consecutive streak of completed fasts
    consecutive_completed = 0
    current_user.fasting_entries.recent.each do |fast|
      if fast.completed?
        consecutive_completed += 1
      else
        break
      end
    end
    consecutive_completed
  end

  def prepare_chart_data
    # Get entries from the last 30 days
    start_date = 30.days.ago.to_date
    end_date = Date.current

    entries = current_user.weight_entries
                          .for_period(start_date, end_date)
                          .order(:date)

    if entries.any?
      @chart_labels = entries.map { |entry| entry.date.strftime("%b %d") }
      @chart_data = entries.map(&:weight)
    else
      @chart_labels = []
      @chart_data = []
    end
  end
end
