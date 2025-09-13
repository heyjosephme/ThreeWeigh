class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @latest_weight = current_user.latest_weight
    @new_weight_entry = current_user.weight_entries.build(date: Date.current)

    # Calculate basic stats
    @total_entries = current_user.weight_entries.count
    @weight_trend = calculate_weight_trend

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
