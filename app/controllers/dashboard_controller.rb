class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @weight_entries = current_user.weight_entries.recent.limit(10)
    @latest_weight = current_user.latest_weight
    @new_weight_entry = current_user.weight_entries.build(date: Date.current)

    # Calculate basic stats
    @total_entries = current_user.weight_entries.count
    @weight_trend = calculate_weight_trend
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
end
